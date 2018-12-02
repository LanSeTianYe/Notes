时间：2018/12/2 11:38:50  

## Lua 协程  

### 协程简介    
  
通过协调执行不同的任务，无论处理器有多少个核心，同一时刻只有一个任务在执行。不会存在数据不一致问题。

线程可以保证多处理器时，每个核心运行一个线程，同时运行多个任务。由于同时运行多个任务，会存在内存和CPU各级缓存数据不一致的问题，因此支持多线程的程序都提供了一定的机制来协调不同线程之间的数据一致性。

**协程的状态**  

* suspended: 挂起，新创建的协程，以及在协程内部执行 `yield` 时，协程处于挂起状态。  
* running: 运行， 对协程执行 `resume` 之后协程处于运行状态。 
* dead：停止，执行结束的协程。

**协程之间通信：**

	coroutine.resume(pt, p1, p2, p3)
	coroutine.yield(p1, p2, p3)

调用 `resume` 之后，协程会执行直到遇到下一个 `yield` 调用， 此时 `yield` 会收到 `resume` 函数传递的参数，并且传递参数给 `resume` 函数。  
  

### Lua 协程实现  

	-- 消费者函数
	local consumer = function(message)
	    print(message)
	end
	
	-- 数据程序
	local sender = function(first)
	    local number = first
	    while true do
	        local message = coroutine.yield("consumer response is : " .. number)
	        consumer(message)
	        number = number + 1
	    end
	end
	
	-- 协程
	local c_t = coroutine.create(sender)
	
	-- 生产者
	local producer = function()
	    local number = 1
	    while true do
	        local status, response = coroutine.resume(c_t, "p_" .. number)
	        print(response)
	        number = number + 1
	        if number > 2 then
	            break
	        end
	    end
	end
	
	-- 第一次调用 resume 参数会传递给协程函数 sender
	-- resume 接受下一次协程执行 yield 函数的返回值
	local status, response = coroutine.resume(c_t, 100)
	print("first response : " .. response)
	
	producer()

 
