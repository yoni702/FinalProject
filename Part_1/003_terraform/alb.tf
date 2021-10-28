resource "aws_lb" "albmasteroll" {
  name               = "albmasteroll"
  internal           = false
  load_balancer_type = "application"
  #Chech this line
  security_groups    = [aws_security_group.allow-alb.id]
  
  subnet_mapping {
    subnet_id     = aws_subnet.masteroll-private-1.id
   
  }

  subnet_mapping {
    subnet_id     = aws_subnet.masteroll-private-2.id
    
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
resource "aws_vpc" "masteroll" {
  cidr_block = "10.0.0.0/16"
}


 #---------------------------Target_group_attachment-----------------------------------

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.masterol-target-group.arn
  target_id        = [aws_instance.WebServer1.id,aws_instance.WebServer2.id]
  port             = 80
}