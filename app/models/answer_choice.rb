class AnswerChoice < ApplicationRecord
  validates :choice, presence: true
  after_destroy :destroy_action

  belongs_to :question,
    class_name: 'Question',
    primary_key: :id,
    foreign_key: :question_id

  has_many :responses,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :answer_id,
    dependent: :destroy

  def destroy_action
    puts "Answer choice #{self.id} destroyed"
  end
end