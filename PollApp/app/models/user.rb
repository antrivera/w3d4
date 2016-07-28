class User < ActiveRecord::Base

  validates :name, uniqueness: true, presence: true

  has_many :authored_polls,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Poll

  has_many :response_ids,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Response

  has_many :responses,
    through: :response_ids,
    source: :answer_choice

  def completed_polls
    #
    # sql_string = <<-SQL
    #   SELECT
    #     *
    #   FROM
    #     questions
    #   JOIN
    #     polls ON polls.id = questions.poll_id
    #   JOIN
    #     answer_choices ON answer_choices.question_id = questions.id
    #   JOIN
    #     (SELECT
    #       *
    #       FROM
    #       responses
    #       WHERE
    #       user_id = ?
    #     ) AS user_responses ON user_responses.answer_id = answer_choices.id
    #   GROUP BY
    #     polls.id
    #   HAVING
    #     COUNT(DISTINCT(questions.id)) = COUNT(user_responses.id)
    # SQL
    #
    # Poll.find_by_sql([sql_string, self.id])

    left_outer_join_str = <<-SQL
      LEFT OUTER JOIN
        (SELECT
          *
          FROM
          responses
          WHERE
          user_id = #{self.id}
        ) AS user_responses ON user_responses.answer_id = answer_choices.id
    SQL

    Poll
      .joins(:questions)
      .joins("JOIN answer_choices ON answer_choices.question_id = questions.id")
      .joins(<<-SQL)
        LEFT OUTER JOIN
          (SELECT
            *
            FROM
            responses
            WHERE
            user_id = #{self.id}
          ) AS user_responses ON user_responses.answer_id = answer_choices.id
      SQL
      .group("polls.id")
      .having("COUNT(DISTINCT(questions.id)) = COUNT(user_responses.id)")
  end

end
