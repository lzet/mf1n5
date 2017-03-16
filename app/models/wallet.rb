class Wallet < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, length: { in: Range.new(1,10) },
                   presence: true
  validates :currency, length: { in: Range.new(1,5) },
                       presence: true
  before_validation :checkinit
  validate :uniq

  def updatevalue
    self.value = self.items.sum(:value)
  end

  private
    def checkinit
      self.value ||= 0
    end

    def uniq
      if self.user
        w = self.user.wallets.find_by(name: self.name)
        errors.add(:name, 'must be unique') if w && w.id != self.id
      end
    end
end
