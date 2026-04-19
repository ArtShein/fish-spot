class Fish < ApplicationRecord
  belongs_to :trip, optional: true

  enum :kind, { peace: 0, predator: 1 }

  after_initialize :apply_default_kind, if: :new_record?

  validates :name, presence: true, if: :trip_id?

  private

  def apply_default_kind
    self.kind ||= :peace
  end
end
