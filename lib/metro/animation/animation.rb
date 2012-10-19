class Animation

  attr_reader :current_step

  def initialize(options)
    @current_step = 0

    options.each do |key,value|
      send :instance_variable_set, "@#{key}".to_sym, value
      self.class.send :define_method, key do
        instance_variable_get("@#{key}")
      end
    end
    after_initialize
  end

  def completed?
    current_step >= interval
  end

  def step!
    return if completed?

    execute_step
    next_step

    complete! if completed?
  end

  def next_step
    @current_step = current_step + step_interval
  end

  def step_interval
    1
  end

  def execute_block_in_context(block_name)
    if respond_to? block_name
      block_to_execute = send(block_name)
      context.instance_eval(&block_to_execute)
    else
      instance_variable_get("@#{block_name}").call
    end
  end

  def execute_step
    execute_block_in_context(:step_block)
  end

  def complete!
    execute_block_in_context(:completed)
  end

  def step(&block)
    @step_block = block if block
  end

  def completed(&block)
    @completed = block if block
  end

end

require_relative 'implicit_animation'
