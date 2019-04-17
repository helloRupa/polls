class Question < ApplicationRecord
  validates :body, presence: true
  after_destroy :destroy_action

  belongs_to :poll,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :poll_id

  has_many :answer_choices,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :question_id,
    dependent: :destroy

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def destroy_action
    puts "Question #{self.id} destroyed"
  end

  def results # hash of answer options and counts of responses
    res = self.answer_choices
            .left_outer_joins(:responses)
            .select('answer_choices.choice AS choice, COUNT(responses.answer_id) AS count')
            .group('responses.answer_id, answer_choices.choice')
    
    return 'No authored answers for this question' if res.empty?
    
    res.each_with_object({}) { |data, h| h[data.choice] = data.count }
  end
end