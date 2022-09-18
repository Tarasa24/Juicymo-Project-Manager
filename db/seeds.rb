# First delete uat user if already present
User.where(email: 'uat@juicymo.cz').destroy_all

user = User.create(
  email: "uat@juicymo.cz",
  password: "123456",
  password_confirmation: "123456",
  first_name: "UAT",
  second_name: "User"
)

project1 = Project.create(
  title: "Project #1",
  position: 1,
  user_id: user.id
)

important_task = Task.create(
  title: "Very important task",
  description: "Task that is very important indeed",
  is_done: false,
  project_id: project1.id,
  user_id: user.id
)
Task.create(
  title: "Less important task",
  description: "",
  is_done: false,
  project_id: project1.id,
  user_id: user.id
)
done_task = Task.create(
  title: "Done task",
  description: "Finally",
  is_done: true,
  project_id: project1.id,
  user_id: user.id
)

project2 = Project.create(
  title: "Project #2",
  position: 2,
  user_id: user.id
)
only_task = Task.create(
  title: "One and only task",
  description: "And its even finished already. YAY!",
  is_done: true,
  project_id: project2.id,
  user_id: user.id
)

project3 = Project.create(
  title: "Project #3",
  position: 3,
  user_id: user.id
)

urgent_tag = Tag.create(
  title: "Urgent",
  user_id: user.id
)
TagsTasks.create(
  tag_id: urgent_tag.id,
  task_id: important_task.id
)
needs_to_be_done_asap_tag = Tag.create(
  title: "Needs to be done ASAP",
  user_id: user.id
)
TagsTasks.create(
  tag_id: needs_to_be_done_asap_tag.id,
  task_id: important_task.id
)

easy_tag = Tag.create(
  title: "Easy",
  user_id: user.id
)
TagsTasks.create!([
  { tag_id: easy_tag.id, task_id: only_task.id },
  { tag_id: easy_tag.id, task_id: done_task.id }
])