module Metro

  #
  # The HitList is an object that maintains when an object is touched/clicked
  # and then moved and finally released. The object attempts to work through
  # the process:
  #
  #     hit_list.hit(first_event)
  #     hit_list.update(next_event)
  #     hit_list.update(next_event)
  #     hit_list.release(last_event)
  #
  #
  # @see EditTransitionScene
  #
  class HitList

    def initialize(drawers)
      @drawers = drawers
    end

    attr_reader :drawers

    def hit(event)
      add drawers_at(event.mouse_x,event.mouse_y)
      save_event event
    end

    def update(event)
      offset_x, offset_y = offset_from_last_event(event)

      list.each { |d| d.offset(offset_x,offset_y) }

      save_event event
    end

    def release(event)
      offset_x, offset_y = offset_from_last_event(event)

      list.each { |d| d.offset(offset_x,offset_y) }

      save_event event
      clear
    end

    def drawers_at(x,y)
      hit_drawers = drawers.find_all { |drawer| drawer.contains?(x,y) }

      # assumed that we only want one item
      top_drawer = hit_drawers.inject(hit_drawers.first) {|top,drawer| drawer.z_order > top.z_order ? drawer : top }
      [ top_drawer ].compact
    end

    def offset_from_last_event(event)
      [ (event.mouse_x - @last_event.mouse_x).to_i, (event.mouse_y - @last_event.mouse_y).to_i ]
    end

    def save_event(event)
      @first_event = event unless @first_event
      @last_event = event
    end

    def list
      @list ||= []
    end

    def add(hits)
      Array(hits).each {|hit| list.push hit }
    end

    def clear
      list.clear
      @first_event = nil
    end

  end
end