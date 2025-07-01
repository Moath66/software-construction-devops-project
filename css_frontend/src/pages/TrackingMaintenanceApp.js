"use client";

import { useEffect, useState } from "react";
import "../styles/TrackingMaintenanceApp.css";
import { getMaintenanceByResident } from "../api/maintenanceApis";
import {
  FaArrowLeft,
  FaBriefcase,
  FaCheck,
  FaExclamationTriangle,
  FaClock,
} from "react-icons/fa";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";

const TrackingMaintenanceApp = () => {
  const [maintenanceList, setMaintenanceList] = useState([]);
  const navigate = useNavigate();

  const fetchData = async () => {
    try {
      const user = JSON.parse(localStorage.getItem("user") || "{}");

      // ✅ DEBUG LOGS - Remove these after fixing
      console.log("🔍 Full user object:", user);
      console.log("🔍 user._id:", user._id);
      console.log("🔍 user.userId:", user.userId);
      console.log("🔍 typeof user.userId:", typeof user.userId);

      // ✅ Check for numeric userId
      if (!user || !user.userId || typeof user.userId !== "number") {
        console.error("❌ Invalid user data:", { user, userId: user?.userId });
        toast.error("Missing or invalid user ID. Please log in again.");
        navigate("/login");
        return;
      }

      console.log("🔍 Calling API with userId:", user.userId);
      const data = await getMaintenanceByResident(user.userId);
      console.log("✅ API Response:", data);

      // Sort by equipment ID (e.g., EQ0001, EQ0002)
      const sorted = [...data].sort((a, b) =>
        (a.equipment_id || "").localeCompare(b.equipment_id || "")
      );
      setMaintenanceList(sorted);
    } catch (error) {
      console.error("❌ Error fetching maintenance data:", error);
      toast.error("❌ Error fetching maintenance data.");
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const getStatusBadge = (action, status) => {
    if (status !== "Completed")
      return (
        <span className="status pending">
          <FaClock /> Pending
        </span>
      );

    switch (action) {
      case "replace":
        return (
          <span className="status orange">
            <FaExclamationTriangle /> Replacement Required
          </span>
        );
      case "checking":
        return (
          <span className="status yellow">
            <FaClock /> Maintenance Scheduled
          </span>
        );
      case "no_checking":
        return (
          <span className="status green">
            <FaCheck /> Good
          </span>
        );
      default:
        return (
          <span className="status pending">
            <FaClock /> Pending
          </span>
        );
    }
  };

  return (
    <div className="lost-page-wrapper">
      <div className="lost-card">
        <header className="profile-header">
          <h2 className="lost-card-title">
            <FaBriefcase className="lost-card-icon" /> Tracking Maintenance
            Application
          </h2>
          <button className="back-btn" onClick={() => navigate(-1)}>
            <FaArrowLeft className="mr-2 h-4 w-4" /> Back to Dashboard
          </button>
        </header>
        <div className="tracking-content">
          <table className="tracking-table">
            <thead>
              <tr>
                <th>Equipment ID</th>
                <th>Equipment Name</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {maintenanceList.length > 0 ? (
                maintenanceList.map((item) => (
                  <tr key={item._id}>
                    <td data-label="Equipment ID">
                      {item.equipment_id || "N/A"}
                    </td>
                    <td data-label="Equipment Name">{item.eq_type}</td>
                    <td data-label="Status">
                      {getStatusBadge(item.staffAction, item.status)}
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="3" className="no-items">
                    No maintenance requests found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default TrackingMaintenanceApp;
