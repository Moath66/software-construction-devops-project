# software-construction-devops-project

## Project Overview
DevOps project for Software Construction course - FYP application

# 🏘️ Community Services System (CSS) – Revolutionizing

A responsive and modular full-stack web application built using the MERN stack (MongoDB, Express.js, React.js, Node.js). The system enhances the efficiency of community service management for residents at D'Summit Residence, enabling digital access to lost and found reports, visitor registration, maintenance requests, and user account control.

---

## 📚 Course Information

- **Course Code**: SECJ4383-03 
- **Course Name**: SOFTWARE CONSTRUCTION
- **Supervisor**:  DR ADILA FIRDAUS BINTI ARBAIN 
- **Institution**: Universiti Teknologi Malaysia (UTM)

---

## 👨‍💻 Project Title  
**Community Services System (CSS): Revolutionizing for Modern Living in D'Summit Residence**

---

## 🛠️ Core Technologies

| Technology                 | Purpose                                     |
|----------------------|---------------------------------------------------|
| React.js	           | 	Frontend interface (SPA)                         |
| Node.js & Express    | Backend APIs and logic                            |
| MongoDB              | Database for users, visitors, items , maintenance |
| QR Code Library      | QR code generation and scan handling              |
| Vercel               | 	Frontend deployment                              |
| Render               | 	Backend deployment                               |
| Git                  | 	Version control                                  |
| Draw.io              | 	UML design and system modeling                   |

---

## 👤 System Roles

- Admin: Manages users accounts

- Resident: Reports lost and found items, maintenance, and visitor requests with tracking their applicatons

- Staff: Handles maintenance analysis request

- Security: Verifies visitors, handles items

---

  ## 🧩 Project Modules
1. User Management – login, profile update

2. Lost & Found – QR-based item reporting, claiming, and tracking

3. Visitor Pre-Registration – Visitor forms with security check-in

4. Maintenance Request – analyze form for resident reports and staff inspection

---

## Technology Stack
- **Backend**: Node.js, Express.js, MongoDB
- **Frontend**: React.js/Next.js
- **Database**: MongoDB
- **DevOps Tools**: Jenkins, Docker, Kubernetes, Jira

## Project Structure
- `css_backend/` - Backend API and server code
- `css_frontend/` - Frontend React application
- `docs/` - Project documentation
- `docker/` - Docker configuration files
- `k8s/` - Kubernetes deployment files

## 🌟 Features

🔐 JWT-based secure authentication

📱 Responsive SPA with React

📦 QR Code generation for item claiming and visitor check-in

📊 Role-based navigation and access

🧾 Tracking modules for maintenance, visitor, and lost item status

🔄 Full CRUD operations with MongoDB

🌐 Hosted on Render (backend) and Vercel (frontend)

---

## ⚙ Setup Instructions:

To run this project locally:

# Clone the repository
git clone https://github.com/yourusername/css-project.git
cd css-project

# Install frontend dependencies
cd css_frontend
npm install

# Start frontend
npm start

# In another terminal, install backend dependencies
cd css_backend
npm install

# Run backend server
node server.js

# Frontend
npm run build

---

## Team Members

|              Name    |                      Role                                       |
|----------------------|-----------------------------------------------------------------|
| Moath  Morsy	       | Team leader / "Set up GitHub repository for DevOps project"     |
| Zuhayer  Siddique	   | Web Developer / "Deploy application using Kubernetes"           |
| Sakif Hossain        | Web Developer / "Configure Jenkins CI/CD Pipeline"              |
| Mohamed Sami	       | Web Developer / "Create Docker containerization for application"|
| Mohammad hatem	     | Web Developer /"Code refactoring and smell detection"           |

