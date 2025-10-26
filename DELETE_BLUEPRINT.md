# How to Delete a Blueprint on Render.com

## 🗑️ Delete Individual Services

Since Render doesn't have a "delete blueprint" button, you need to delete each service individually:

### Step 1: Go to Dashboard
https://dashboard.render.com

### Step 2: Delete Each Service

For each service (user-service, submission-service, assignment-frontend):

1. **Click on the service** to open it
2. Scroll down to the bottom of the Settings page
3. Find the **"Delete Web Service"** button (red button at the bottom)
4. Click **"Delete Web Service"**
5. **Type the service name** to confirm
6. Click **"Delete"**

### Step 3: Delete Database

1. Go to the **PostgreSQL database** (assignment-db)
2. Go to **Settings** tab
3. Scroll to bottom
4. Click **"Delete PostgreSQL"** (red button)
5. **Type the database name** to confirm
6. Click **"Delete"**

---

## ⚡ Quick Order to Delete:

1. ✅ Delete `assignment-frontend` (Static Site)
2. ✅ Delete `submission-service` (Web Service)
3. ✅ Delete `user-service` (Web Service)
4. ✅ Delete `assignment-db` (PostgreSQL Database) - **Delete this LAST**

**Why this order?** Services depend on the database, so delete services first, then database.

---

## 🔄 After Deletion

Once all services are deleted:
- Blueprint configuration is removed
- No charges (was free anyway)
- You can redeploy anytime using the same render.yaml

---

**That's it! Services will be permanently deleted.** 🗑️
