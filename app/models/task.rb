class Task < ApplicationRecord
  enum :priority, {
    lowest: 0,
    low: 1,
    normal: 2,
    high: 3,
    highest: 4
  }, prefix: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }, allow_nil: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :overdue, -> { where("due_date < ? AND completed = ?", Date.current, false) }
  scope :due_today, -> { where(due_date: Date.current) }
  scope :due_this_week, -> { where(due_date: Date.current.beginning_of_week..Date.current.end_of_week) }
  scope :by_priority, -> { order(priority: :asc) }
  scope :high_priority, -> { where("priority >= ?", priorities["high"]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :ordered, -> { order(position: :asc, created_at: :asc) }

  def overdue?
    due_date.present? && !completed? && due_date < Date.current
  end
end
