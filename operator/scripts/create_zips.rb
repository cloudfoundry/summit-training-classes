# Run this script using the students.json output from create-vpc.
# It provides all the environment variables needed for students to deploy their
# own BOSH directors in AWS.

require 'json'
require 'fileutils'

if ARGV.length != 1 then
  puts "Usage: #{File.basename($0)} students.json"
  exit(1)
end

students = ARGV[0]

students_file = File.read(students)

students_hash = JSON.parse(students_file)

FileUtils::mkdir_p 'students'

students_hash.each_with_index do |student,index|
  student_dir = "students/student-#{index}"
  FileUtils::mkdir_p student_dir

  File.write("#{student_dir}/private_key.pem", student["private_key"])

  vars = <<-EOF
# source this file to export these variables (needed to deploy BOSH Lite v2 on AWS)
export DIRECTOR_NAME=director-#{index}
export INTERNAL_CIDR=#{student["internal_cidr"]}
export INTERNAL_GW=#{student["internal_gw"]}
export INTERNAL_IP=#{student["internal_ip"]}
export AWS_ACCESS_KEY_ID=#{student["access_key_id"]}
export AWS_SECRET_ACCESS_KEY=#{student["secret_access_key"]}
export AWS_DEFAULT_REGION=#{student["region"]}
export AZ=#{student["az"]}
export DEFAULT_KEY_NAME=#{student["default_key_name"]}
export SUBNET_ID=#{student["subnet_id"]}
export EXTERNAL_IP=#{student["external_ip"]}
  EOF

  File.write("#{student_dir}/export_vars", vars)

  Dir.chdir(student_dir)
  system("zip -r ../student-#{index}.zip ./*")
  Dir.chdir("../..")
  FileUtils.rm_rf(student_dir)
end
