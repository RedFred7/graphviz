# Copyright (c) 2013 Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'stringio'

module Graphviz
	class Node
		def initialize(graph, name, options)
			@graph = graph
			@graph.nodes[name] = self
			
			@name = name
			@options = options
			
			@edges = []
		end
		
		attr :name
		attr :options
		
		attr :edges
		
		def connect(destination, options = {})
			edge = Edge.new(@graph, self, destination, options)
			
			@edges << edge
			
			return edge
		end
		
		def add_node(name, options = {})
			node = Node.new(@graph, name, options)
			
			connect(node)
			
			return node
		end
	end
	
	class Edge
		def initialize(graph, source, destination, options = {})
			@graph = graph
			@graph.edges << self
			
			@source = source
			@destination = destination
			
			@options = options
		end
		
		attr :source
		attr :destination
		
		attr :options
		
		def to_s
			"->"
		end
	end
	
	class Graph
		def initialize(name = 'G', options = {})
			@name = name
			
			@nodes = {}
			@edges = []
		end
		
		attr :nodes
		attr :edges
		
		def add_node(name, options = {})
			Node.new(self, name, options)
		end
		
		def to_dot(options = {})
			buffer = StringIO.new
			
			format = options[:format] || 'digraph'
			
			buffer.puts "#{format} #{@name} {"
			
			@nodes.each do |(name, node)|
				if node.edges.size > 0
					node.edges.each do |edge|
						buffer.puts "\t#{edge.source.name.dump} #{edge} #{edge.destination.name.dump};"
					end
				else
					buffer.puts "\t#{node.name.dump};"
				end
			end
			
			buffer.puts "}"
			
			return buffer.string
		end
	end
end
