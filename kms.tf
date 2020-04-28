resource "aws_kms_key" "jenkins-kms"{
          description = "Encrypt Data at rest in EFS"
         policy = "{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", \"Action\": \"kms:*\",\"Principal\":   \"*\", \"Resource\":   \"*\", \"Sid\":\"Enable IAM User permissions\"}}"
}


resource "aws_kms_key" "git-kms"{
          description = "Encrypt Data at rest in EFS"
         policy = "{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", \"Action\": \"kms:*\",\"Principal\":   \"*\", \"Resource\":   \"*\", \"Sid\":\"Enable IAM User permissions\"}}"
}

