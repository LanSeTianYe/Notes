--一个简单的列子
function list_iter (t)
	local i = 0
	local n = table.getn(t)
	return function ()
		i = i + 1
		if i <= n then return t[i] end
	end
end

helpful_guys = {
	"----翻译人员列表---",
	"buxiu","凤舞影天","zhangsan",
	"morler", "lambda",
	"\n",
	"--------参与校对-------",
	"凤舞影天", "doyle","flicker","花生魔人",
	"\n"
}

for e in list_iter (helpful_guys) do
	print(e)
end


--函数
print(os.date())

print 'sunfeilong'


--简单的函数
function testFunctionParams(a,b)
	print (a,b)
end
--调用函数
testFunctionParams('q')


function getMaxNumAndValue(a)
	local index = 1
	local maxValue = a[index]
	for i, val in ipairs(a) do
		if (val > maxValue)  then
			maxValue = val
			index = i;
		end
	end
	return index , maxValue
end


print(getMaxNumAndValue({1,5,4,3,2,6}))

--窗体
--w = Window {
--	x = 0, y = 0, width = 300, height = 200, title = 'Lua', background = 'blue',border = true
--}

function Window(options)

	if type(options.title) ~= 'string' then
		error('no titile')
	elseif type(options.width) ~= 'number' then
		error('no width')
	elseif type(options.heigh) ~= 'number' then
		error('no height')
	end

	_Window(
			options.title,
			options.x or 0,
			options.y or 0,
			options.widtjh,
			options.height,
			options.background or 'red',
			options.border
			)
end


--
function eraseTerminal()
	io.write("\27[2J")
end
-- writes an `*' at column `x' , row `y'
function mark (x,y)
	io.write(string.format("\27[%d;%dH*", y, x))
end
-- Terminal size
TermSize = {w = 80, h = 24}
-- plot a function
-- (assume that domain and image are in the range [-1,1])
function plot (f)
	eraseTerminal()
for i=1,TermSize.w do
	local x = (i/TermSize.w)*2 - 1
	local y = (f(x) + 1)/2 * TermSize.h
	mark(i, y)
end
	io.read() -- wait before spoiling the screen
end

--plot(function(x) return math.sin(x*2*math.pi) end)


local name =  'sunfeilong'
--获取字符串的长度
print (string.len(name))
print (#name)
--转换为小写
print (string.lower(name))
--转换为大写
print (string.upper(name))
--第n个开始截取m个
print (string.sub(name,1,2))

--table
local nameTables = {1,2,3}
--将数组转换为字符串
print (table.concat(nameTables))
--将数组转换为字符串，并指定开始位置和链接的个数
print (table.concat(nameTables,'o',1,3))
--向数组中添加元素，默认添加在数组的结尾
table.insert(nameTables, 5)
table.insert(nameTables,4,4)
print (table.concat(nameTables, ',' ,1 ,5))
--从数组中删除一个元素，默认删除最后一个
table.remove(nameTables,4)
print (table.concat(nameTables, ',' ,1 ,4))
table.remove(nameTables)
print (table.concat(nameTables, ',' ,1 ,3))


--Math库
print (math.abs(-1))
print (math.sin(0.1))
print (math.cos(0.1))
print (math.tan(0.1))
--进一取整
print (math.ceil(0.1))
print (math.floor(0.1))
print (math.max(1,2,3,4,56,132))
print (math.min(1,213,213,31,23,123,123,12))
--2的3次方
print (math.pow(2,3))
--平方根
print (math.sqrt(4))
--随机数
print (math.random(4,5))
math.randomseed(10)
print (math.random(4,5))


--cJson库
local cjson = require "json"
local people = {
	name = 'sunfeilong ',
	age = 20
}

local people_json = cjson.encode(people)
print (people_json)
local people_unjson = cjson.decode(people_json)
print (people_unjson.name)





