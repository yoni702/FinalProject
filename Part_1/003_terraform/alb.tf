resource "aws_lb" "albmasteroll" {
  name               = "albmasteroll"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-alb.id]
  

  subnet_mapping {
    subnet_id     = aws_subnet.masteroll-public-1.id
 
   
  }

  subnet_mapping {
    subnet_id     = aws_subnet.masteroll-public-2.id
    
  }

  tags = {
    Environment = "production"
  }
}

# ---------------------------aws_lb_listener-----------------------------------
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.albmasteroll.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.masterol-target-group.arn
  }
}

# ---------------------------Instance_target_group-----------------------------------
resource "aws_lb_target_group" "masterol-target-group" {
  name     = "masterol-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.masteroll.id 
  
}
 #---------------------------Target_group_attachment-----------------------------------

resource "aws_lb_target_group_attachment" "TGA1" {
  target_group_arn = aws_lb_target_group.masterol-target-group.arn
  target_id        = aws_instance.WebServer1.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "TGA2" {
  target_group_arn = aws_lb_target_group.masterol-target-group.arn
  target_id        = aws_instance.WebServer2.id
  port             = 80
}



#IP of aws instance retrieved
output "Dns-Alb-masteroll" {
  value = aws_lb.albmasteroll.dns_name
}