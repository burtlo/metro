class Animation

  attr_reader :current_step
  
  attr_reader :step_block, :complete_block

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

  def execute_step
    context.instance_eval(&@step_block) if step_block and context
  end

  def complete!
    context.instance_eval(&@complete_block) if complete_block and context
  end

  def on_step(&block)
    @step_block = block
  end

  def on_complete(&block)
    @complete_block = block
  end

end

require_relative 'implicit_animation'
