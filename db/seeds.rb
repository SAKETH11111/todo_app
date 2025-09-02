# Idempotent seed data for development/testing of Task features.
# Safe to run multiple times: Tasks are keyed by unique title.

return unless defined?(Task)

today = Date.current
week_start = today.beginning_of_week
week_end = today.end_of_week

samples = [
  { title: "Pay rent",
    description: "Monthly rent via ACH.",
    completed: false,
    due_date: (today.beginning_of_month + 4.days rescue today + 4.days),
    priority: :high,
    position: 1 },

  { title: "Email project status update",
    description: "Summarize progress, blockers, and next steps to the team.",
    completed: false,
    due_date: today,
    priority: :normal,
    position: 2 },

  { title: "Grocery shopping",
    description: nil,
    completed: true,
    due_date: today - 1.day,
    priority: :low,
    position: 3 },

  { title: "Book dentist appointment",
    description: "Routine cleaning in the next two weeks.",
    completed: false,
    due_date: week_end,
    priority: :low,
    position: 4 },

  { title: "Backup laptop",
    description: "Run full backup and verify snapshot integrity.",
    completed: false,
    due_date: nil,
    priority: :lowest,
    position: 5 },

  { title: "Prepare quarterly taxes",
    description: "Collect invoices, expenses, and submit estimates.",
    completed: false,
    due_date: today + 20.days,
    priority: :highest,
    position: 6 },

  { title: "Refactor onboarding docs",
    description: "Improve clarity, add screenshots, and update steps.",
    completed: false,
    due_date: week_start + 2.days,
    priority: :normal,
    position: 7 },

  { title: "Call plumber",
    description: "Fix slow drain in the kitchen sink.",
    completed: false,
    due_date: today - 3.days, # overdue
    priority: :high,
    position: 8 },

  { title: "Read architecture RFC",
    description: "Provide feedback by EOD tomorrow.",
    completed: false,
    due_date: today + 1.day,
    priority: :normal,
    position: 9 },

  { title: "Ship v1.0.1 patch release",
    description: "Hotfix for login bug; includes regression test.",
    completed: true,
    due_date: today - 2.days,
    priority: :high,
    position: 10 },

  { title: "Long form writing session",
    description: "".ljust(1200, "A"),
    completed: false,
    due_date: nil,
    priority: nil, # intentionally unset
    position: 11 },

  { title: "Clean inbox to zero",
    description: nil,
    completed: false,
    due_date: today,
    priority: :low,
    position: 12 },

  { title: "Schedule 1:1s",
    description: "Set recurring biweekly 1:1s with reports.",
    completed: false,
    due_date: today + 7.days,
    priority: :normal,
    position: 13 },

  { title: "Migrate staging database",
    description: "Run migration window off-hours; monitor Solid Queue.",
    completed: false,
    due_date: week_end - 1.day,
    priority: :highest,
    position: 14 },

  { title: "Renew driver’s license",
    description: "Check required documents before appointment.",
    completed: false,
    due_date: today + 30.days,
    priority: :low,
    position: 15 },

  { title: "Fix flaky test: tasks#overdue",
    description: "Stabilize date math around week boundaries.",
    completed: false,
    due_date: today - 7.days, # overdue edge
    priority: :high,
    position: 16 },

  { title: "Very long task title to test UI truncation and wrapping behavior in list views and detail modals",
    description: "Ensure long titles do not break layout.",
    completed: false,
    due_date: nil,
    priority: :normal,
    position: 17 },

  { title: "Completed without due date",
    description: "Should not appear in overdue scope.",
    completed: true,
    due_date: nil,
    priority: :low,
    position: 18 },

  { title: "Overdue without priority",
    description: "Covers overdue + nil priority edge.",
    completed: false,
    due_date: today - 1.day,
    priority: nil,
    position: 19 }
]

samples.each_with_index do |attrs, i|
  rec = Task.find_or_initialize_by(title: attrs[:title])
  # Ensure position is stable even if the array changes
  rec.assign_attributes(attrs.merge(position: attrs[:position] || (i + 1)))
  rec.save!
end

puts "Seeded tasks: #{samples.size} (idempotent by title)"
