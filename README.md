#  Strapi CMS Deployment on AWS using Terraform

This project demonstrates deploying a **Strapi headless CMS** on **AWS EC2** using **Infrastructure as Code (IaC)** with **Terraform**.
It is created as part of a DevOps assignment requiring:

* IaC-based deployment
* Cloud-hosted Strapi instance
* Working API endpoint
* GitHub repository
* Video walkthrough with face visible

---

##  **Project Overview**

This setup deploys:

* **AWS EC2 (Ubuntu 22.04)**
* **Docker & Docker Compose (installed automatically)**
* **PostgreSQL database**
* **Strapi CMS in production mode**

Terraform handles all cloud resources, while Docker Compose manages Strapi + PostgreSQL on the server.

---

## **Architecture Diagram (Simple)**

```
Terraform → AWS EC2 → Docker Compose → { Strapi + PostgreSQL }
```

---

##  **Repository Structure**

```
Strapi-project/
│
├── infra/
│   ├── main.tf                 # AWS resources (EC2, security groups)
│   ├── variables.tf            # Input variables (region, instance type, etc.)
│   ├── terraform.tfvars        # Variable values (DB password, key pair)
│   ├── outputs.tf              # Outputs public IP
│   ├── terraform.tfstate       # Included for assessment purposes
│   └── terraform.tfstate.backup
│
└── README.md
```

>  Note: `tfstate` files are intentionally included because this is an assignment and no sensitive cloud keys are exposed.

---

##  **Terraform Deployment Steps**

### 1. Clone the repository

```bash
git clone https://github.com/Shantanu-2001/Strapi-project.git
cd Strapi-project/infra
```

### 2️. Initialize Terraform

```bash
terraform init
```

### 3️. Review or update variables

(Inside `variables.tf` and `terraform.tfvars`)

### 4️. Deploy the infrastructure

```bash
terraform apply -auto-approve
```

### 5️. Get EC2 public IP

```bash
terraform output
```

---

##  **Accessing Strapi**

### Admin Panel

```
http://<PUBLIC-IP>:1337/admin
```

### Example API Endpoint

```
http://<PUBLIC-IP>:1337/api/articles
```

After creating and publishing an article, your API returns structured JSON.

---

##  **Docker Setup on EC2 (Automated)**

Terraform user-data script installs:

* Docker
* Docker Compose
* A production-ready `docker-compose.yml` containing:

  * `postgres` service (with persistent volume)
  * `strapi` service (production build)

Containers start automatically on EC2 boot.

---

##  **Environment Variables Used**

The following are passed into Docker from Terraform:

* `DATABASE_CLIENT=postgres`
* `DATABASE_HOST=postgres`
* `DATABASE_USERNAME=strapi`
* `DATABASE_PASSWORD=StrapiDemoPass123!`
* `APP_KEYS`
* `JWT_SECRET`
* `ADMIN_JWT_SECRET`
* `API_TOKEN_SALT`

---

##  **Testing the API**

Once Strapi is ready:

### Fetch all articles:

```
GET http://<PUBLIC-IP>:1337/api/articles
```

Example JSON:

```json
{
  "id": 1,
  "title": "First Article",
  "content": "This is my first article deployed via Terraform on AWS.",
  "published": true
}
```

---

##  **Technologies Used**

* Terraform
* AWS EC2
* Docker
* Docker Compose
* Strapi CMS
* PostgreSQL
* Ubuntu Linux

---

##  **Conclusion**

This project successfully demonstrates:

* Infrastructure as Code
* Cloud hosting
* Containerized application deployment
* Production-ready Strapi instance
* Working API endpoint

A complete DevOps workflow from provisioning → deployment → testing ✔️

---

