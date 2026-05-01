# **Table Naming Convention**
### **Bronze Rules**
- All names must start with the source system name and table names must match their original names without renaming.
- **sourcesystem_entity**
  -  **sourcesystem:** Name of the source system (e.g., crm, erp).
  -  **entity:** Exact table name from the source system
  - **Example:** crm_customer_info > Customer information from the CRM system.
     
  ### **Silver Rules**
- All names must start with the source system name and table names must match their original names without renaming.
- **sourcesystem_entity**
  -  **sourcesystem:** Name of the source system (e.g., crm, erp).
  -  **entity:** Exact table name from the source system
  -  **Example:** crm_customer_info > Customer information from the CRM system.
 
  ### **Gold Rules**
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **category_entity**
  - **category:** Describes the role of the table, such as **dim (dimension)** or **fact (fact table)**
  - **entity:** Descriptive name of the table, aligned with the business domain (e.g., customers, products, sales).
  - **Example:**

     - dim_customers > Dimension table for customer data.
     - fact_sales > Fact table containing sales transactions.

 **Glossary of category Patterns**
  |Pattern|Meaning|Examples(s)|
  |-------|-------|-----------|
  |dim_|Dimension table|dim_customer, dim_product|
  |fact_|Fact table|fact_sales|
  |agg_|Aggregatged table|agg_customers, agg_sales_monthly|

### **Surrogate Keys**
- All primary keys in dimension tables must use the suffix _key.
- **<table_name_key>**
  -  **<table_name>:** Refers to the name of the table or entity the key belongs to.
  -  **_key:** A suffix indicating that this coulmn is a surrogate key.
  -  **Example:** customer_key > surrogate  key in the dim_custommers table
