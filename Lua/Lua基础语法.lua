--һ���򵥵�����
function list_iter (t)
	local i = 0
	local n = table.getn(t)
	return function ()
		i = i + 1
		if i <= n then return t[i] end
	end
end

helpful_guys = {
	"----������Ա�б�---",
	"buxiu","����Ӱ��","zhangsan",
	"morler", "lambda",
	"\n",
	"--------����У��-------",
	"����Ӱ��", "doyle","flicker","����ħ��",
	"\n"
}

for e in list_iter (helpful_guys) do
	print(e)
end


--����
print(os.date())

print 'sunfeilong'


--�򵥵ĺ���
function testFunctionParams(a,b)
	print (a,b)
end
--���ú���
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

--����
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
--��ȡ�ַ����ĳ���
print (string.len(name))
print (#name)
--ת��ΪСд
print (string.lower(name))
--ת��Ϊ��д
print (string.upper(name))
--��n����ʼ��ȡm��
print (string.sub(name,1,2))

--table
local nameTables = {1,2,3}
--������ת��Ϊ�ַ���
print (table.concat(nameTables))
--������ת��Ϊ�ַ�������ָ����ʼλ�ú����ӵĸ���
print (table.concat(nameTables,'o',1,3))
--�����������Ԫ�أ�Ĭ�����������Ľ�β
table.insert(nameTables, 5)
table.insert(nameTables,4,4)
print (table.concat(nameTables, ',' ,1 ,5))
--��������ɾ��һ��Ԫ�أ�Ĭ��ɾ�����һ��
table.remove(nameTables,4)
print (table.concat(nameTables, ',' ,1 ,4))
table.remove(nameTables)
print (table.concat(nameTables, ',' ,1 ,3))


--Math��
print (math.abs(-1))
print (math.sin(0.1))
print (math.cos(0.1))
print (math.tan(0.1))
--��һȡ��
print (math.ceil(0.1))
print (math.floor(0.1))
print (math.max(1,2,3,4,56,132))
print (math.min(1,213,213,31,23,123,123,12))
--2��3�η�
print (math.pow(2,3))
--ƽ����
print (math.sqrt(4))
--�����
print (math.random(4,5))
math.randomseed(10)
print (math.random(4,5))


--cJson��
local cjson = require "json"
local people = {
	name = 'sunfeilong ',
	age = 20
}

local people_json = cjson.encode(people)
print (people_json)
local people_unjson = cjson.decode(people_json)
print (people_unjson.name)





