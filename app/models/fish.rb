class Fish < ApplicationRecord
  enum type: {
    peace: 0,
    predator: 1
  }
end
