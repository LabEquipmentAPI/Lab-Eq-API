# Lab Equipment API

## Project Description
A lightweight Ruby on Rails API designed to track department lab equipment, manage categories, record maintenance histories, and enforce strict business rules for data integrity.

## 📋 Task Assignment Table

| Task | Description | Assigned Owner | Branch Name | Status |
| :---: | :--- | :--- | :--- | :--- |
| **1** | Data model and migrations | **Yishak Medhin** | `Task-1-Data-Model` | 🟢 Done |
| **2** | Seed data | **Yishak Medhin** | `Task-2-Seed-data` | 🟢 Done |
| **3** | Category CRUD with delete protection | **Soleyana Yonas** | `Task-3-Category-CRUD` | 🟢 Done | 
| **4** | Equipment CRUD with filtering | **Yabtsega Demis** | `Task-4-Equipment-CRUD` | 🟢 Done |
| **5** | Maintenance Record CRUD with filtering | **Nahot Haile** | `Task-5-MaintenanceRecord-CRUD` | 🟢 Done |
| **6** | Business rules (4 custom validations) | **Yohannes Mesfin** | `Task-6-Business-rules` | 🟢 Done |
| **7** | Edge case testing and curl documentation| **Nebiyu Samuel** | `Task-7-Edge-case-testing` | 🟢 Done |

## Setup and Installation

Follow these steps to clone the repository and configure the application locally:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/LabEquipmentAPI/Lab-Eq-API.git
   cd Lab-Eq-API
   ```

2. **Install project dependencies**:
   ```bash
   bundle install
   ```

3. **Initialize the database, run migrations, and seed records**:
   ```bash
   bin/rails db:create db:migrate db:seed
   ```

4. **Launch the local development server**:
   ```bash
   bin/rails server
   ```
   The API will now be running and accessible locally at `http://localhost:3000`.

## 🔀 Endpoint Reference

This API provides full CRUD operations for all three core entities with flat, non-nested routes.

### 1. Categories (`/categories`)

| Method | Path | Description |
| :--- | :--- | :--- |
| **GET** | `/categories` | Fetches all categories, sorted alphabetically by name. |
| **GET** | `/categories/:id` | Fetches a single category, including a calculated total count of its assigned equipment. |
| **POST** | `/categories` | Creates a new category. Name must be unique and contain at least 3 characters. |
| **PATCH/PUT** | `/categories/:id` | Updates an existing category name. |
| **DELETE** | `/categories/:id` | Deletes a category. Returns a `409 Conflict` error if any equipment items are still assigned to it. |

### 2. Equipment (`/equipment`)

| Method | Path | Description |
| :--- | :--- | :--- |
| **GET** | `/equipment` | Fetches all equipment ordered by name. Supports filtering by status via query param (e.g., `?status=available`). Automatically resolves parent category names safely without causing N+1 database traps. |
| **GET** | `/equipment/:id` | Fetches a single equipment item, including full category details and all associated maintenance history logs sorted with the newest entries first (`performed_at desc`). |
| **POST** | `/equipment` | Creates a new equipment item. Validates the required `category_id` exists, enforces that the serial number matches the strict `XXX-NNN` pattern, and requires names to contain real text elements. |
| **PATCH/PUT** | `/equipment/:id` | Updates an existing equipment item's fields. |
| **DELETE** | `/equipment/:id` | Deletes an equipment item. This operation cascades automatically and cleans up all matching child maintenance logs from the database. |

### 3. Maintenance Records (`/maintenance_records`)

| Method | Path | Description |
| :--- | :--- | :--- |
| **GET** | `/maintenance_records` | Fetches all maintenance logs sorted by execution date descending (`performed_at DESC`). Supports filtering logs by parent item via query param (e.g., `?equipment_id=3`). |
| **GET** | `/maintenance_records/:id` | Fetches a single maintenance log entry, including its parent equipment's descriptive name. |
| **POST** | `/maintenance_records` | Creates a new maintenance record. Validates the target `equipment_id` is real and ensures the date `performed_at` is not set in the future. |
| **PATCH/PUT** | `/maintenance_records/:id` | Updates an existing maintenance record's entries. |
| **DELETE** | `/maintenance_records/:id` | Permanently deletes a single maintenance log entry from the database. |

## 🛡️ Global Exception and Response Rules

* **Validation Failures (422 Unprocessable Entity):** Any bad data or violated business rules will return an array of human-readable descriptions under a unified key: `{"errors": ["Name can't be blank"]}`.
* **Missing Records (404 Not Found):** Requesting non-existent entity IDs triggers a standardized JSON footprint: `{"error": "Record not found"}` rather than throwing system error crashes.
* **Successful Deletions (204 No Content):** Deleting a valid entity outputs a clean response with an empty body and a `204 No Content` status code.
