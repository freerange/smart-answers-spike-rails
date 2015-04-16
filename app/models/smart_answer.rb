require 'forwardable'

class SmartAnswer
  class MaintenanceGrant
    MAXIMUM = 3387
    HOUSEHOLD_INCOME_LOWER_THRESHOLD = 25000
    HOUSEHOLD_INCOME_UPPER_THRESHOLD = 42620
    HOUSEHOLD_INCOME_DIVISOR = 5.28

    attr_reader :student

    def initialize(student)
      @student = student
    end
    
    def available?
      student.uk_origin? && student.full_time?
    end
    
    def amount
      case student.household_income
      when 0..HOUSEHOLD_INCOME_LOWER_THRESHOLD
        MAXIMUM
      when (HOUSEHOLD_INCOME_LOWER_THRESHOLD + 1)..HOUSEHOLD_INCOME_UPPER_THRESHOLD
        household_income_above_lower_threshold = (student.household_income - HOUSEHOLD_INCOME_LOWER_THRESHOLD)
        MAXIMUM - (household_income_above_lower_threshold / HOUSEHOLD_INCOME_DIVISOR).floor
      else
        0
      end
    end
  end
  
  class ChildcareGrant
    attr_reader :student

    def initialize(student)
      @student = student
    end
    
    def available?
      student.has_children && student.uk_origin? && student.full_time?
    end
  end
  
  class Student
    EU = :eu
    UK = :uk

    PART_TIME = :part_time
    FULL_TIME = :full_time

    attr_accessor :study_mode
    attr_accessor :student_origin
    attr_accessor :tuition_fees
    attr_accessor :has_children
    attr_accessor :household_income
    
    def full_time?
      study_mode == FULL_TIME
    end
  
    def uk_origin?
      student_origin == UK
    end
  end
  
  FULL_TIME_TUITION_FEES_MAXIMUM = 9000
  PART_TIME_TUITION_FEES_MAXIMUM = 6750
  
  extend Forwardable

  def_delegator :@student, :study_mode, :study_mode
  def_delegator :@student, :student_origin, :student_origin
  def_delegator :@student, :tuition_fees, :tuition_fees
  def_delegator :@student, :has_children, :has_children
  def_delegator :@student, :household_income, :household_income

  def_delegator :@student, :study_mode=, :study_mode=
  def_delegator :@student, :student_origin=, :student_origin=
  def_delegator :@student, :tuition_fees=, :tuition_fees=
  def_delegator :@student, :has_children=, :has_children=
  def_delegator :@student, :household_income=, :household_income=
  
  def_delegator :@student, :full_time?, :full_time?
  def_delegator :@student, :uk_origin?, :uk_origin?

  def initialize
    @student = Student.new
    @maintenance_grant = MaintenanceGrant.new(@student)
    @childcare_grant = ChildcareGrant.new(@student)
  end
  
  def outcome
    "#{student_origin_info} #{study_mode_info} #{tuition_fees_info} #{childcare_grant_info} #{maintenance_grant_info}"
  end
  
  def valid?
    if full_time?
      tuition_fees <= FULL_TIME_TUITION_FEES_MAXIMUM
    else
      tuition_fees <= PART_TIME_TUITION_FEES_MAXIMUM
    end
  end
  
  def student_origin_info
    @student.uk_origin? ? 'UK' : 'EU'
  end
  
  def study_mode_info
    @student.full_time? ? 'Full-Time' : 'Part-Time'
  end
  
  def tuition_fees_info
    "Tuition fees: #{tuition_fees}"
  end

  def childcare_grant_info
    return 'Info about childcare grant' if @childcare_grant.available?
  end
  
  def maintenance_grant_info
    return "Maintenance grant: #{@maintenance_grant.amount}" if @maintenance_grant.available?
  end
end
