class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :authored_polls,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :author_id

  has_many :responses,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :user_id

  has_many :answered_questions,
    through: :responses,
    source: :question

  has_many :answered_polls,
    Proc.new { distinct },
    through: :answered_questions,
    source: :poll

  def completed_polls
    Poll.find_by_sql([<<-SQL, self.id])
      SELECT
        polls.*
      FROM
        polls
      JOIN
        questions ON questions.poll_id = polls.id
      LEFT JOIN
        (
          SELECT
            answer_choices.question_id AS q_id
          FROM
            answer_choices
          JOIN
            responses ON responses.answer_id = answer_choices.id
          WHERE
            responses.user_id = ?
        ) AS answers ON answers.q_id = questions.id
      GROUP BY
        polls.id
      HAVING
        COUNT(questions.poll_id) = COUNT(answers.q_id)
    SQL
  end
end