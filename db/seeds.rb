# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Department.create(name: "Support")
Department.create(name: "Sales")

IssueStatus.create(name: "Waiting for Staff Response", is_default: true, is_closed: false)
IssueStatus.create(name: "Waiting for Customer", is_default: false, is_closed: false)
IssueStatus.create(name: "On Hold", is_default: false, is_closed: false)
IssueStatus.create(name: "Cancelled", is_default: false, is_closed: true)
IssueStatus.create(name: "Completed", is_default: false, is_closed: true)

Staff.create(login: "", hashed_password: "", name: "Nobody", mail: "", department_id: 0, admin: false)
Staff.create(login: "admin", hashed_password: "test123", name: "Admin", mail: "redden.tears@gmail.com", department_id: 1, admin: true)
