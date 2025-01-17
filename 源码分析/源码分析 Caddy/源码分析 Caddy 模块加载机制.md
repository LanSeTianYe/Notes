时间：2025-01-17 10:45:45

参考：

1. [https://github.com/caddyserver/caddy.git](https://github.com/caddyserver/caddy.git)


## 源码分析 Caddy 模块加载机制

### Caddy 模块定义

```go
// Module 模块接口，模块需要实现该接口
type Module interface {
	// This method indicates that the type is a Caddy
	// module. The returned ModuleInfo must have both
	// a name and a constructor function. This method
	// must not have any side-effects.
	CaddyModule() ModuleInfo
}

// ModuleInfo 模块信息
// ID                 模块的标识
// New func() Module  创建模块实例（加载模块时使用该方法创建模块实例）
type ModuleInfo struct {
	// ID is the "full name" of the module. It
	// must be unique and properly namespaced.
	ID ModuleID

	// New returns a pointer to a new, empty
	// instance of the module's type. This
	// method must not have any side-effects,
	// and no other initialization should
	// occur within it. Any initialization
	// of the returned value should be done
	// in a Provision() method (see the
	// Provisioner interface).
	New func() Module
}
```


### Caddy 模块实现

以 `caddyhttp.APP` 为例，相关代码如下：

```go
package caddyhttp

type App struct {
}

// 实现 Module 接口
// CaddyModule returns the Caddy module information.
func (App) CaddyModule() caddy.ModuleInfo {
	return caddy.ModuleInfo{
		ID:  "http",
		New: func() caddy.Module { return new(App) },
	}
}
```


### Caddy 模块注册

模块会在包的 `init()` 方法中进行注册。当包被引用的时候 `init()` 方法自动执行，然后注册模块。

注册代码如下:

```go
package caddyhttp

func init() {
	caddy.RegisterModule(App{})
}
```

模块注册代码：

```go
package caddy

// RegisterModule 注册模块信息
func RegisterModule(instance Module) {
  
	mod := instance.CaddyModule()

	if val := mod.New(); val == nil {
		panic("ModuleInfo.New must return a non-nil module instance")
	}

	modulesMu.Lock()
	defer modulesMu.Unlock()

	modules[string(mod.ID)] = mod
}
```


### Caddy 模块加载

第一步：找到对应的模块，创建实例。`modInfo.New()`

第二步：通过反序列化初始化实例属性。`StrictUnmarshalJSON(rawMsg, &val)`

第三步：调用 `Provisioner` 方法，如果有的话。

第四部：调用 `Validator` 方法，验证属性配置是否正确，如果有的话。



**核心代码：**

```go
// 根据id加载模块
func (ctx Context) LoadModuleByID(id string, rawMsg json.RawMessage) (any, error) {
	modulesMu.RLock()
	modInfo, ok := modules[id]
	modulesMu.RUnlock()
  
  // 创建模块实例
	val := modInfo.New()


  // 通过反序列化初始化模块属性
	// fill in its config only if there is a config to fill in
	if len(rawMsg) > 0 {
		err := StrictUnmarshalJSON(rawMsg, &val)
		if err != nil {
			return nil, fmt.Errorf("decoding module config: %s: %v", modInfo, err)
		}
	}

	ctx.ancestry = append(ctx.ancestry, val)

  // 模块加载后执行一些操作，比如加载其它模块、预初始化一些信息
	if prov, ok := val.(Provisioner); ok {
		err := prov.Provision(ctx)
		if err != nil {
			// incomplete provisioning could have left state
			// dangling, so make sure it gets cleaned up
			if cleanerUpper, ok := val.(CleanerUpper); ok {
				err2 := cleanerUpper.Cleanup()
				if err2 != nil {
					err = fmt.Errorf("%v; additionally, cleanup: %v", err, err2)
				}
			}
			return nil, fmt.Errorf("provision %s: %v", modInfo, err)
		}
	}

  // 验证模块配置是否合法
	if validator, ok := val.(Validator); ok {
		err := validator.Validate()
		if err != nil {
			// since the module was already provisioned, make sure we clean up
			if cleanerUpper, ok := val.(CleanerUpper); ok {
				err2 := cleanerUpper.Cleanup()
				if err2 != nil {
					err = fmt.Errorf("%v; additionally, cleanup: %v", err, err2)
				}
			}
			return nil, fmt.Errorf("%s: invalid configuration: %v", modInfo, err)
		}
	}

	ctx.moduleInstances[id] = append(ctx.moduleInstances[id], val)

	return val, nil
}
```