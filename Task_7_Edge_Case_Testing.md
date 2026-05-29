
```

# Task 7: Edge Case Testing

## 1. Create equipment with category_id: 999 (does not exist) — expects 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Orphan","serial_number":"XXX-000","status":"available","category_id":999}}'
```

**Response:**
```json
{"errors":["Category must exist"]}
```

**Status:** 422

---

## 2. Create equipment with duplicate serial number — expects 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Dup","serial_number":"UNQ-999","status":"available","category_id":1}}'

curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Dup2","serial_number":"UNQ-999","status":"available","category_id":1}}'
```

**Response (second request):**
```json
{"errors":["Serial number has already been taken"]}
```

**Status:** 422

---

## 3. Create equipment with status broken (not in allowed list) — expects 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Bad","serial_number":"ZZZ-999","status":"broken","category_id":1}}'
```

**Response:**
```json
{"errors":["Status is not included in the list"]}
```

**Status:** 422

---

## 4. Create category with duplicate name — expects 422

```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"Computing"}}'
```

**Response:**
```json
{"errors":["Name has already been taken"]}
```

**Status:** 422

---

## 5. Create maintenance record with equipment_id: 999 (does not exist) — expects 422

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"description":"Fix","performed_at":"2024-01-01T00:00:00","equipment_id":999}}'
```

**Response:**
```json
{"errors":["Equipment must exist"]}
```

**Status:** 422

---

## 6. DELETE /categories/1 when equipment belongs to it — expects 409

```bash
curl -X DELETE http://localhost:3000/categories/1
```

**Response:**
```json
{"error":"Cannot delete category. 3 equipment items still belong to it."}
```

**Status:** 409

---

## 7. GET /categories/999 — expects 404

```bash
curl -X GET http://localhost:3000/categories/999
```

**Response:**
```json
{"error":"Category not found"}
```

**Status:** 404

---

## 8. GET /equipment/999 — expects 404

```bash
curl -X GET http://localhost:3000/equipment/999
```

**Response:**
```json
{"error":"Equipment not found"}
```

**Status:** 404

---

## 9. PATCH /categories/999 — expects 404

```bash
curl -X PATCH http://localhost:3000/categories/999 \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"New Name"}}'
```

**Response:**
```json
{"error":"Category not found"}
```

**Status:** 404

---

## 10. POST /maintenance_records with future performed_at — expects 422

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"description":"Future fix","performed_at":"2099-01-01T00:00:00","equipment_id":1}}'
```

**Response:**
```json
{"errors":["Performed at cannot be in the future"]}
```

**Status:** 422