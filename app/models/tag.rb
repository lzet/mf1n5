class Tag < ApplicationRecord
  has_many :descriptions
  has_many :items, through: :descriptions
  belongs_to :user
  validates :name, length: { minimum: 1 },
                   presence: true,
                   format: {with: /\A[^,]+\z/}
  before_create :checkcolor
  validate :uniq

  def checkcolor
    if !self.color || self.color === '#000000'
      rnd = Random.new
      r = rnd.rand(250)
      g = rnd.rand(250)
      b = rnd.rand(250)
      res = "##{r.to_s(16)}#{g.to_s(16)}#{b.to_s(16)}"
      if res.length < 7
        self.color = res + ('0'*(7 - res.length))
      else
        self.color = res
      end
    end
  end

  private
    def uniq
      if self.user
        t = self.user.tags.find_by(name: self.name)
        errors.add(:name, 'must be unique') if t && t.id != self.id
      end
    end
end
