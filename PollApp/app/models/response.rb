class Response < ActiveRecord::Base
  validates :answer_id, :user_id, presence: true
  # validate :respondent_already_answered?, :respondent_answered_own_poll?
  validates_uniqueness_of :user_id, scope: :answer_id

  belongs_to :answer_choice,
    primary_key: :id,
    foreign_key: :answer_id,
    class_name: :AnswerChoice

  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << "Already responded to this question."
    end
  end

  def respondent_answered_own_poll?
    # if question.poll.author_id  == self.user_id
    #   errors[:user_id] << "Author can't answer own poll."
    # end

    poll = Poll
      .joins(:questions)
      .joins("JOIN answer_choices ON answer_choices.question_id = questions.id")
      .joins("JOIN responses ON responses.answer_id = answer_choices.id")
      .where("responses.id = ?", self.id)

    # if poll.author_id == self.user_id
    #   errors[:user_id] << "Author can't answer own poll."
    # end

  end

end
