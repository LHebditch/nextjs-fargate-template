resource "docker_image" "app" {
  name = "nextjs_image"
  build {
    context   = ".."
    tag       = ["nextjs_image:develop"]
    build_arg = {}
    label     = {}
  }
}

module "container" {
  source     = "github.com/LHebditch/terraform-fargate-module?ref=9ad334"
  cluster_id = ""
  name       = "LHTEST"
  tags = {
    "env" : "dev"
  }
  task_cpu      = 512
  task_memory   = 1024
  region        = "eu-west-1"
  port_mappings = [3000]
  environment = [
    { "name" : "VARNAME", "value" : "VARVAL" }
  ]
  container_image = docker_image.app.image_id
  task_count      = 1
  security_groups = [
    "sg-b8366cf4"
  ]
  subnets = [
    "subnet-004e6b66",
    "subnet-708aed2a"
  ]
  assign_public_ip   = true
  role_arn           = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}
