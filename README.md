# 🥐 The Golden Oven – Artisan Bakery

> A full-stack online bakery ordering web application built with HTML, CSS, JavaScript, JSP, JDBC, and MySQL — deployed on Apache Tomcat.

---

## 📌 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Order Flow](#order-flow)
- [Setup & Installation](#setup--installation)
- [Running the Project](#running-the-project)
- [Testing the Order System](#testing-the-order-system)
- [Common Errors & Fixes](#common-errors--fixes)
- [Author](#author)

---

## 📖 About the Project

**The Golden Oven** is a web application simulating an online artisan bakery store. It allows customers to browse bakery products (cakes, pastries, breads, and cookies), manage a cart and wishlist, and place orders directly through a form-based interface.

Order data is submitted via a standard HTML form to a JSP backend, which connects to a MySQL database using JDBC and stores the order details — no Servlets, no Fetch API.

---

## ✨ Features

- 🏠 **Home page** with hero section, featured products, and testimonials
- 🛍️ **Product catalogue** with category filters and sort options
- 🔍 **Live search** across all products
- ❤️ **Wishlist** stored in browser localStorage
- 🛒 **Cart** with quantity controls, coupon field, and delivery calculation
- 📋 **Order placement form** collecting customer name, phone, address, product, and quantity
- 💾 **JSP + JDBC backend** — form data inserted directly into MySQL
- ✅ **Order confirmation page** showing order ID and saved details
- 📱 **Fully responsive** design for mobile, tablet, and desktop

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | HTML5, CSS3, JavaScript (Vanilla) |
| Backend | JSP (JavaServer Pages) |
| Database Connectivity | JDBC (Java Database Connectivity) |
| Database | MySQL 8.x |
| Server | Apache Tomcat 10.x |
| IDE | Eclipse IDE for Java EE |
| Fonts & Icons | Google Fonts, Font Awesome 6 |

> ⚠️ No Servlets, no Fetch API, no frameworks — pure JSP + JDBC as required.

---

## 📁 Project Structure

```
golden-oven-jsp/
│
├── WebContent/
│   ├── index.jsp                            ← Main website (frontend + order form)
│   ├── order.jsp                            ← JSP backend: JDBC → MySQL → confirmation
│   └── WEB-INF/
│       ├── web.xml                          ← Tomcat deployment descriptor
│       └── lib/
│           └── mysql-connector-j-8.x.x.jar ← ⚠️ Must be added manually
│
├── database.sql                             ← MySQL setup script (create DB + table)
└── README.md                                ← This file
```

---

## 🗃️ Database Schema

**Database name:** `golden_oven_db`

**Table: `orders`**

| Column | Type | Description |
|---|---|---|
| `id` | INT, AUTO_INCREMENT, PK | Unique order ID |
| `customer_name` | VARCHAR(150), NOT NULL | Customer's full name |
| `phone` | VARCHAR(20), NOT NULL | Customer's phone number |
| `address` | TEXT, NOT NULL | Delivery address |
| `product_name` | VARCHAR(200), NOT NULL | Name of the product ordered |
| `quantity` | INT, NOT NULL, DEFAULT 1 | Number of units ordered |
| `order_date` | TIMESTAMP, DEFAULT NOW() | Auto-set at time of insertion |

```sql
CREATE TABLE orders (
    id            INT           NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(150)  NOT NULL,
    phone         VARCHAR(20)   NOT NULL,
    address       TEXT          NOT NULL,
    product_name  VARCHAR(200)  NOT NULL,
    quantity      INT           NOT NULL DEFAULT 1,
    order_date    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 🔄 Order Flow

```
Customer fills Order Form (index.jsp)
            │
            │   <form action="order.jsp" method="post">
            ▼
      order.jsp receives POST request
            │
            │   request.getParameter("customerName", "phone", ...)
            ▼
      Server-side validation
            │
            ├── if invalid → show error page, go back
            │
            └── if valid ──────────────────────────────────┐
                                                           ▼
                                                  JDBC Connection
                                       Class.forName("com.mysql.cj.jdbc.Driver")
                                       DriverManager.getConnection(url, user, pass)
                                                           │
                                                           ▼
                                                  PreparedStatement
                                       INSERT INTO orders (customer_name, phone,
                                                  address, product_name, quantity)
                                       VALUES (?, ?, ?, ?, ?)
                                                           │
                                                           ▼
                                       MySQL stores row → returns generated ID
                                                           │
                                                           ▼
                                       order.jsp renders Order Confirmed page
                                       Shows: Order ID · Name · Phone · Product · Qty
```

---

## ⚙️ Setup & Installation

### Prerequisites

Make sure the following are installed before you begin:

| Software | Version | Download |
|---|---|---|
| Java JDK | 11 or later | https://www.oracle.com/java/technologies/downloads/ |
| Apache Tomcat | 10.x | https://tomcat.apache.org/download-10.cgi |
| MySQL Server | 8.x | https://dev.mysql.com/downloads/mysql/ |
| MySQL Workbench | Any | https://dev.mysql.com/downloads/workbench/ |
| Eclipse IDE for Java EE | Latest | https://www.eclipse.org/downloads/ |
| MySQL JDBC Connector | 8.x | https://dev.mysql.com/downloads/connector/j/ |

---

### Step 1 — Set Up the MySQL Database

1. Open **MySQL Workbench** and connect to your local server.
2. Open `database.sql` from this project (File → Open SQL Script).
3. Click **Execute (⚡)** to run the script. It will:
   - Create the `golden_oven_db` database
   - Create the `orders` table
   - Insert 4 sample rows for testing

4. Verify everything was created:
   ```sql
   USE golden_oven_db;
   SHOW TABLES;
   SELECT * FROM orders;
   ```

   **Alternative (Command Line):**
   ```bash
   mysql -u root -p < database.sql
   ```

---

### Step 2 — Add the MySQL JDBC Driver

1. Download `mysql-connector-j-8.x.x.jar` from:
   https://dev.mysql.com/downloads/connector/j/
   (Select "Platform Independent" → Download the ZIP → extract the JAR)

2. Copy the `.jar` file into:
   ```
   WebContent/WEB-INF/lib/
   ```

3. In Eclipse, right-click the JAR → **Build Path → Add to Build Path**

---

### Step 3 — Configure Database Credentials

Open `WebContent/order.jsp` and update the three lines at the top of the scriptlet (~line 40):

```java
String DB_URL  = "jdbc:mysql://localhost:3306/golden_oven_db?useSSL=false&serverTimezone=Asia/Kolkata";
String DB_USER = "root";        // ← replace with your MySQL username
String DB_PASS = "password";    // ← replace with your MySQL password
```

---

### Step 4 — Import Project into Eclipse

1. Open **Eclipse IDE for Enterprise Java**
2. Go to **File → Import → General → Existing Projects into Workspace**
3. Click **Browse**, select the `golden-oven-jsp` folder, click **Finish**
4. In the **Servers** tab, add **Apache Tomcat 10.x** if not already configured:
   - Window → Preferences → Server → Runtime Environments → Add → Apache Tomcat v10.x → browse to your Tomcat installation folder

---

## ▶️ Running the Project

1. Right-click the project in Eclipse → **Run As → Run on Server**
2. Select your **Apache Tomcat 10.x** server → click **Finish**
3. Eclipse will deploy the project and open Tomcat automatically
4. Open your browser and go to:

```
http://localhost:8080/golden-oven-jsp/
```

---

## 🧪 Testing the Order System

1. Open the website at `http://localhost:8080/golden-oven-jsp/`
2. Click **"Place an Order"** in the navigation bar or hero section
3. Fill in the order form:
   - **Full Name** — e.g. `Priya Sharma`
   - **Phone Number** — e.g. `9876543210`
   - **Delivery Address** — e.g. `12, MG Road, Bengaluru`
   - **Product** — select from the dropdown
   - **Quantity** — e.g. `2`
4. Click **"Place Order"**
5. You will be redirected to the **Order Confirmed** page showing your unique Order ID

### Verify in MySQL

Run this query in MySQL Workbench to confirm the data was saved:

```sql
SELECT * FROM golden_oven_db.orders ORDER BY id DESC;
```

Each order placed through the form will appear as a new row in the table.

---

## 💡 Common Errors & Fixes

| Error Message | Cause | Fix |
|---|---|---|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | JDBC JAR missing | Add `mysql-connector-j.jar` to `WEB-INF/lib/` and restart Tomcat |
| `Access denied for user 'root'@'localhost'` | Wrong DB credentials | Update `DB_USER` and `DB_PASS` in `order.jsp` |
| `Unknown database 'golden_oven_db'` | Database not created | Run `database.sql` in MySQL Workbench |
| `Table 'golden_oven_db.orders' doesn't exist` | Table not created | Re-run `database.sql` |
| `Connection refused` | MySQL not running | Start MySQL via XAMPP Control Panel or system services |
| `404 – /golden-oven-jsp/ not found` | Wrong context path | Check project name matches URL in browser |
| `HTTP 500 – Internal Server Error` | JSP compilation error | Check Eclipse console for the exact Java error |

---

## 👤 Author

**Prajana**

Project: The Golden Oven – Artisan Bakery
Stack: HTML · CSS · JavaScript · JSP · JDBC · MySQL · Apache Tomcat
