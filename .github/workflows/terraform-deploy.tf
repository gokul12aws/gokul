name: terraform Deployment

on: 
 workflow_dispatch:
   
jobs: 
  terraform:
    runs-on: ubuntu-latest 

    steps:
    - name: checkout code
      uses: actions/checkout@v4

    
    - name: set up terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: "1.4.0" 
        
    - name: aws credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-region: us-west-2
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_ACCESS_KEY_ID }}
     
 

    - name: Terraform Init
      run: terraform init
      
    - name: Terraform plan
      run: terraform plan -out=tfplan
      
    - name: Terraform Apply
      run: terraform apply -auto-approve tfplan

    - name: Terraform Destroy
      run: terraform destroy -auto-approve




     
  
      
      
