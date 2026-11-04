resource "aws_instance" "roboshop" {
  count = length(var.instances)   #if someone forgets to mention count it automatically takes count of instances  
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]
  #in this section we get to know about merging and 
  #length() where it automatically takes the count
  tags = merge(
    var.common_tags,
    {
      Component = var.instances[count.index]
      Name = var.instances[count.index]
    }
  )
}
resource "aws_security_group" "allow_all" {
    name        = var.sg_name
    description = var.sg_description

    ingress {
        from_port        = var.from_port
        to_port          = var.to_port
        protocol         = "-1"
        cidr_blocks      = var.cidr_blocks
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = var.from_port
        to_port          = var.to_port
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    

     tags = merge(
      var.common_tags,
      {
        Name = "allow-all"
      }
     )
    
}

/* In a real DevOps job, when you open the AWS Console, the Terraform = true tag can help you identify resources that are marked as Terraform-managed.
How this helps in a real job
Imagine your company has 500 EC2 instances. Some were created manually in AWS, and others were created using Terraform.
Name	Project	Terraform	What it tells you
mongodb	roboshop	true	  Marked as Terraform-managed
redis	roboshop	   true	    Marked as Terraform-managed
test-server	testing	 No tag	Management method unknown
When an engineer opens an instance, they can use the tags to understand which project it belongs to and how it may have been provisioned.
One important thing to remember
Terraform = true is only a label. It does not prove that Terraform currently manages the resource. Someone could manually add that tag, too.
In a real job, engineers may also check:
- The Terraform configuration files in GitHub.
- The Terraform state file to see which resources Terraform tracks.
- The team's deployment process and documentation. */