require 'rails_helper'

RSpec.describe SearchHelper, type: :helper do
  context 'link' do
    it 'returns url of search results depending on its type' do
      result = { 'type' => 'Project', 'id' => 1 }
      expect(helper.link(result)).to eq('/projects/1')
      result = { 'type' => 'Task', 'project_id' => 1, 'id' => 1 }
      expect(helper.link(result)).to eq('/projects/1/tasks/1')
      result = { 'type' => 'Tag', 'title' => 'title' }
      expect(helper.link(result)).to eq('/tags?query=title')
    end
  end
end
