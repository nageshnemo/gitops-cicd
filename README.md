# **Infrastructure Automation and CI/CD Pipeline for Python Application Deployment**

This project demonstrates end-to-end automation of infrastructure provisioning using **Terraform**, application containerization using **Docker**, artifact management, and deployment on **Kubernetes**. The CI/CD pipeline ensures seamless integration and delivery of the Python application.

---

## **Project Overview**

This project is designed to showcase modern DevOps practices by automating the following tasks:

1. **Infrastructure Provisioning**: Terraform is used to create cloud infrastructure.
2. **Application Containerization**: A Python application is containerized using Docker and pushed to an artifact registry.
3. **Deployment**: Kubernetes is used to deploy and manage the containerized application.
4. **CI/CD Pipeline**: GitHub Actions (or any other CI/CD tool) orchestrates the entire process, ensuring continuous integration and delivery.

---

## **Technologies Used**

- **Terraform**: For infrastructure as code (IaC).
- **Docker**: To containerize the Python application.
- **Artifact Registry**: To store Docker images securely.
- **Kubernetes**: For container orchestration.
- **GitHub Actions**: To implement the CI/CD pipeline.
- **Python**: For the sample application.

---

## **Repository Structure**

```
.
├── terraform/                   # Contains Terraform configuration files
├── app/                         # Python application source code
│   ├── app.py                   # Main application file
│   ├── requirements.txt         # Python dependencies
├── Dockerfile                   # Dockerfile to build the application image
├── k8s/                         # Kubernetes manifest files
│   ├── deployment.yaml          # Kubernetes Deployment
│   ├── service.yaml             # Kubernetes Service
├── .github/workflows/           # GitHub Actions workflows
│   ├── ci-cd-pipeline.yaml      # CI/CD workflow definition
├── README.md                    # Project documentation
```

---

## **Setup and Usage**

### **1. Clone the Repository**
```bash
git clone <repository-url>
cd <repository-name>
```

### **2. Infrastructure Setup with Terraform**

1. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```
   This creates the necessary cloud infrastructure, including Kubernetes clusters and artifact registry.

---

### **3. Build and Push Docker Image**

1. Build the Docker image:
   ```bash
   docker build -t <artifact-registry-url>/<image-name>:<tag> .
   ```
2. Authenticate with the artifact registry:
   ```bash
   docker login <artifact-registry-url>
   ```
3. Push the image:
   ```bash
   docker push <artifact-registry-url>/<image-name>:<tag>
   ```

---

### **4. Deploy to Kubernetes**

1. Navigate to the Kubernetes manifests directory:
   ```bash
   cd k8s
   ```
2. Apply the Kubernetes manifests:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

---

### **5. CI/CD Pipeline**

The CI/CD pipeline is triggered on every push to the main branch. Key steps in the pipeline:
- **Build**: Builds the Docker image of the application.
- **Push**: Pushes the Docker image to the artifact registry.
- **Deploy**: Deploys the updated image to the Kubernetes cluster.

---

## **Key Features**

- **Terraform Automation**: Infrastructure provisioning is automated with Terraform, ensuring consistency and repeatability.
- **Dockerized Application**: The Python application is containerized for portability and scalability.
- **Artifact Registry**: Secure storage for container images.
- **Kubernetes Deployment**: Highly available and scalable deployment using Kubernetes.
- **CI/CD**: End-to-end pipeline to automate build, test, and deployment.

---

## **How to Contribute**

1. Fork this repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-branch
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-branch
   ```
5. Open a pull request.

---

## **Future Enhancements**

- Implement **Helm** for templating Kubernetes manifests.
- Add **unit tests** and integrate them into the CI/CD pipeline.
- Monitor application performance using **Prometheus** and **Grafana**.
- Introduce **HashiCorp Vault** for secrets management.

---

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## **Acknowledgments**

Special thanks to everyone who contributed to this project and supported its development.

---

## **Contact**

Feel free to reach out with questions or suggestions:

- **Name**: Nagesh Kumar Singh  
- **Email**: [singhnages319@gmail.com](mailto:singhnages319@gmail.com)  
- **LinkedIn**: [linkedin.com/in/nageshkumar](https://linkedin.com/in/nagesh-kumar-singh)

---


<img width="1470" alt="image" src="https://github.com/user-attachments/assets/12f1ef29-9ad9-479c-bc00-d6e87f3025b0">


<img width="1356" alt="image" src="https://github.com/user-attachments/assets/a61c7ac5-a844-4850-b44f-12386a51dad8">

