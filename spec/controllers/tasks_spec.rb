require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  scenario "使用這建立一個新的任務" do
    visit new_task_path

    fill_in "Name", with: "New Task"
    fill_in "Content", with: "New Task Content"
    select "高", from: "Priority"
    select "未完成", from: "Status"

    select_date_and_time(Time.now, from: 'task_start_time')
    select_date_and_time(Time.now + 1.hour, from: 'task_end_time')

    click_button "Create Task"

    expect(page).to have_text("成功建立任務！")
    expect(page).to have_text("New Task")
  end

  scenario "使用者檢視一個任務" do
    visit task_path(task)

    expect(page).to have_text(task.name)
    expect(page).to have_text(task.content)
  end

  scenario "使用者編輯一個任務" do
    visit edit_task_path(task)

    fill_in "Name", with: "Updated Task"
    click_button "Update Task"

    expect(page).to have_text("成功更新任務！")
    expect(page).to have_text("Updated Task")
  end

  scenario "使用者刪除一個任務" do
    visit tasks_path

    within "#task_#{task.id}" do
      click_link "Destroy"
    end

    expect(page).to have_text("成功刪除任務！")
    expect(page).not_to have_text("Test Task")
  end
end
