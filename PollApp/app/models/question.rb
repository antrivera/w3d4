class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true

  belongs_to :poll,
    primary_key: :id,
    foreign_key: :poll_id,
    class_name: :Poll

  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: :AnswerChoice

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    # N+1 QUERY
    # result_hash = {}
    # answer_choices.each do |answer_choice|
    #   result_hash[answer_choice.text] = answer_choice.responses.count
    # end
    # result_hash

    # # 2 QUERIES
    # result_hash = {}
    # answers = self.answer_choices.includes(:responses)
    # answers.each do |answer|
    #   result_hash[answer.text] = answer.responses.length
    # end
    # result_hash

    # answers = find_by_sql([<<-SQL
    #   SELECT
    #     answer_choices.*, COUNT(answer_choices.*)
    #   FROM
    #     answer_choices
    #   LEFT OUTER JOIN
    #     responses ON answer_choices.id = responses.answer_id
    #   JOIN
    #     questions ON answer_choices.question_id = questions.id
    #   WHERE
    #     answer_choices.question_id = ?
    #   GROUP BY
    #     answer_choices.id
    # SQL
    #  , self.id])

    result_hash = {}
    answers = answer_choices
      .select("answer_choices.*, COUNT(responses.*) AS response_count")
      .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_id")
      .joins(:question)
      .where(question_id: self.id)
      .group("answer_choices.id")

    answers.each do |answer|
      result_hash[answer.text] = answer.response_count
    end

    result_hash
  end

end
