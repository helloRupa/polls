class Response < ApplicationRecord
  before_validation :not_duplicate_response, :not_own_question
  after_destroy :destroy_action

  belongs_to :answer_choice,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :answer_id

  belongs_to :respondent,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  has_one :question,
    through: :answer_choice,
    source: :question

  def not_own_question
    errors.add(:user_id, message: "Can't answer your own poll") if own_question?
  end

  def own_question?
    poll_author == self.user_id
  end

  def poll_author
    self.question.poll.author.id
  end

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.exists?(user_id: self.user_id)
  end

  def not_duplicate_response
    errors.add(:user_id, message: 'Only one response/user allowed') if respondent_already_answered?
  end

  def destroy_action
    puts "Response #{self.id} destroyed"
  end
end