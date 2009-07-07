=begin
=end
module BinaryTree
  class Node
    attr_accessor :val, :lchild, :rchild
    def initialize(val)
      @val, @lchild, @rchild=val, nil, nil
    end
    # find the right most child
    def rmost
      cursor=self
      until cursor.rchild.nil?
        cursor=cursor.rchild
      end
      cursor
    end
    def height
      BinaryTree.height(self)
    end
  end
  class Tree
    include BinaryTree
    attr_accessor :size, :root
    def initialize
      @size=0
    end
    def add(val)
      if @size==0 then
        @root=Node.new(val)
        @size=@size+1
      else
        node=@root.rmost
        node.rchild=Node.new(val)
      end
    end
    def each(&functor)
      each_node do |n|
        yield(n.val)
      end
    end
    def each_node(&functor)
      if block_given? then
        cursor=@root
        inorder(cursor, functor)
      else
        nil
      end
    end
  end
  def inorder(cursor, functor)
    unless cursor.nil?
      inorder cursor.lchild, functor
      functor.call cursor
      inorder cursor.rchild, functor
    end
  end
  def BinaryTree.height(node)
    unless node.nil?
      return [height(node.lchild),height(node.rchild)].max + 1
    else
      return 0
    end
  end

end
module AVLTree
  class Node < BinaryTree::Node
    attr_accessor :bf
    def initialize(val)
      super(val)
      @bf=0
    end
    #balance factor
    #should not use this function to calculate bf, 
    #we use a filed to track the value of bf
=begin
    def bf 
      BinaryTree.height(@lchild) - BinaryTree.height(@rchild)
    end
=end
  end
  class Tree < BinaryTree::Tree
    def initialize
      super
    end
    #a is track critical node
    #which is the first node
    #whose bf is not zero
    #
    #d track of delta of bf
    #
    #
    #LR
    #
    def add(val)
      puts "add #{val}"
      unless @root.nil? 
        cursor, d = @root, 0
        cursor_parent = a = a_parent = newnode = b = c = nil
        #find the location to add node of val
        until cursor.nil?
          a, a_parent=cursor, cursor_parent if cursor.bf.abs > 0
          if val < cursor.val 
            cursor_parent, cursor=cursor, cursor.lchild
          elsif val > cursor.val
            cursor_parent, cursor=cursor, cursor.rchild
          else
            return #raise has the same value in the tree exception
          end
        end
        #add the new node of val
        if val < cursor_parent.val
          newnode, cursor_parent.lchild=Node.new(val), newnode
        else
          newnode, cursor_parent.rchild=Node.new(val), newnode
        end
        #calculate d and find b
        if val < a.val
          d, cursor, b=1, a.lchild, a.lchild
        else
          d, cursor, b=-1, a.rchild, a.rchild
        end
        #adjust bf in nodes in path from a to newnode 
        until cursor==newnode
          if val < a.val
            cursor.bf, cursor=1, cursor.lchild
          else
            cursor.bf, cursor=-1, cursor.rchild
          end
        end
        #tree is balance
        if a.bf == 0 
          a.bf=d 
          return
        end
        if a.bf + d == 0 
          a.bf=0 
          return
        end
        #tree is unbalance
        if d == 1 #newnode add in lchild
          if b.bf == 1 # LL type
            a.lchild, b.rchild=b.rchild, a
          else # LR type
            c=b.rchild
            b.rchild, a.lchild,c.lchild, c.rchild = c.lchild, c.rchild, b, a
            case c.bf
            when 1  #LR(b)
              a.bf, b.bf=-1,0
            when -1 #LR(c)
              a.bf, b.bf=0, 1
            else    #LR(a)
              a.bf, b.bf=0,0
            end
          end
        else
          if b.bf == -1 # RR type
            a.rchild, b.lchild=b.lchild, a
          else # RL type
            c=b.lchild
            b.lchild, a.rchild,c.lchild, c.rchild = c.rchild, c.lchild, a, b
            case c.bf
            when 1  #RL(b)
              a.bf, b.bf=-1,0
            when -1 #RL(c)
              a.bf, b.bf=0, 1
            else    #RL(a)
              a.bf, b.bf=0,0
            end
          end
        end
        AVLTree.add(@root, val)
      else
        #puts "val #{val} as root"
        @root=Node.new(val)
        #puts "rootval is #{@root.val}"
      end
    end
  end

  def AVLTree.add(node, val)
    #puts "nodeval is #{node.val} and val is #{val}"
    if val < node.val then
      unless node.lchild.nil?
        AVLTree.add(node.lchild, val)
      else
        node.lchild=Node.new(val)
      end
    else
      unless node.rchild.nil?
        AVLTree.add(node.rchild, val)
      else
        node.rchild=Node.new(val)
      end
    end
  end
end
=begin
testing code
3,2,5,6,4,1
       3
      / \
     2   5
    /    /\
   1    4  6
            \
             7
              \
               8
=end
tree = AVLTree::Tree.new
tree.add(3)
tree.add(2)
tree.add(5)
tree.add(6)
tree.add(7)
tree.add(8)
tree.add(4)
tree.add(1)
tree.each do |v|
  puts v
end
tree.each_node do |n|
  puts n.val
  puts "hieght is #{n.height}, bf is #{n.bf}"
end
