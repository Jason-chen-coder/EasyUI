# AppBridge 开发指南

## 🚀 快速开始

AppBridge 是 Flutter 和 H5 页面之间的通信桥梁。H5 开发者主要使用 **`window.as`** 对象来调用 Flutter 提供的能力。

Flutter 侧示例中的 `bridge` 指当前 WebView 对应的 `AppBridge` 实例（例如 `final bridge = AppBridge();` 并传入 `H5WebView`）。

### 核心概念

```javascript
// H5 侧最常用的调用方式
window.as.方法名(参数);
```

**`as`** 是一个代理对象，它让你可以像调用普通 JavaScript 函数一样调用 Flutter 端的方法，支持：

- ✅ 自动转换为 Promise
- ✅ 自动处理参数传递
- ✅ 支持超时和错误处理

---

## 📋 内置方法列表

AppBridge 提供了以下内置方法，可直接使用：

### `as.getCapabilities()`

获取当前 AppBridge 支持的所有方法和能力。

```javascript
const capabilities = await window.as.getCapabilities();
console.log("支持的方法：", capabilities.methods);
// 输出: ['as.getInfo', 'as.selectFile', 'as.downloadBlob', ...]
```

### `as.getInfo()`

获取设备和应用信息。

```javascript
const info = await window.as.getInfo();
console.log("设备信息：", info);
// 输出: { device: 'Android', version: '1.0', platform: 'mobile' }
```

### `as.selectFile(options?)`

打开文件选择器供用户选择文件。

```javascript
const result = await window.as.selectFile({
  type: "image",
  multiple: true,
});
```

### `as.downloadBlob(data)`

下载 Blob 数据（如 Base64 编码的文件）到本地文件系统。

```javascript
await window.as.downloadBlob({
  base64: "data:application/octet-stream;base64,JVBERi0xLjQK...",
  filename: "export.xlsx",
  mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
});
```

### `as.saveProtocol(data)`

保存 AlphaTool 协议数据。

```javascript
await window.as.saveProtocol(protocolString)
// 或
await window.as.saveProtocol({ name: 'Protocol', data: {...} })
```

---

## 💡 如何添加新方法

添加新方法只需两步：**Flutter 注册** + **H5 调用**

### 示例 1：无参数方法

```dart
// Flutter 侧注册
bridge.register('as.getCurrentUser', (params) async {
  final user = await getUserFromDatabase();
  return {
    'success': true,
    'data': {'id': user.id, 'name': user.name}
  };
},
  description: '获取当前登录用户',
  paramsDescription: '无参数'
);
```

```javascript
// H5 侧调用
const user = await window.as.getCurrentUser();
console.log(user.data.name);
```

### 示例 2：单参数方法

```dart
// Flutter 侧注册
bridge.register('as.updateProfile', (params) async {
  final profile = params as Map; // 自动解包
  await updateProfile(profile);
  return {'success': true};
},
  description: '更新用户资料',
  paramsDescription: 'Map 格式，包含 name、email 等字段'
);
```

```javascript
// H5 侧调用
await window.as.updateProfile({
  name: "John",
  email: "john@example.com",
});
```

### 示例 3：多参数方法

```dart
// Flutter 侧注册
bridge.register('as.uploadFile', (params) async {
  final filePath = params[0];
  final metadata = params[1] as Map;

  final url = await upload(filePath, metadata);
  return {'success': true, 'url': url};
},
  description: '上传文件',
  paramsDescription: '参数1: 文件路径, 参数2: 元数据对象'
);
```

```javascript
// H5 侧调用
const result = await window.as.uploadFile("/path/to/file", {
  type: "image",
  tags: ["tag1"],
});
console.log(result.url);
```

---

## 🎯 参数自动解包机制

为了简化参数处理，AppBridge 实现了智能参数解包：

| H5 调用方式             | Flutter 接收到的 params | 说明                  |
| ----------------------- | ----------------------- | --------------------- |
| `as.method()`           | `[]`                    | 无参数 → 空数组       |
| `as.method(arg)`        | `arg`                   | **单参数 → 自动解包** |
| `as.method(arg1, arg2)` | `[arg1, arg2]`          | 多参数 → 数组         |

**优势**：大多数方法只需要一个参数，自动解包省去了 `params[0]` 或判断 `params is List` 的步骤。

---

## 💡 最佳实践

### ✅ 推荐做法

1. **总是添加错误处理**

   ```javascript
   try {
     const result = await window.as.someMethod();
   } catch (error) {
     console.error("调用失败：", error.message);
   }
   ```

2. **使用有意义的方法名**

   ```dart
   // 好
   bridge.register('as.getUserProfile', ...)

   // 不好
   bridge.register('as.get', ...)
   ```

3. **统一返回格式**

   ```dart
   // 推荐格式
   return {
     'success': true,
     'data': {...},      // 成功时的数据
     'error': '...'      // 失败时的错误信息
   };
   ```

4. **添加完整的文档**
   ```dart
   bridge.register('as.methodName', (params) async {
     // ...
   },
     description: '简短描述这个方法做什么',
     paramsDescription: '''详细的参数说明
   参数格式：...
   H5 调用示例：...'''
   );
   ```

### ❌ 避免的做法

1. **不要忽略异常**

   ```javascript
   // ❌ 不好
   window.as.someMethod(); // 没有 await 或 catch

   // ✅ 好
   try {
     await window.as.someMethod();
   } catch (e) {
     console.error(e);
   }
   ```

2. **不要使用不一致的返回格式**

   ```dart
   // ❌ 不好 - 格式不一致
   return result;                    // 有时返回原始数据
   return {'data': result};          // 有时包装
   return {'success': true, 'data': result}; // 有时加 success
   ```

3. **不要在单参数方法中手动解包**

   ```dart
   // ❌ 不必要 - AppBridge 已经自动解包
   bridge.register('as.save', (params) async {
     final data = params is List ? params[0] : params; // 多余
   });

   // ✅ 好 - 直接使用
   bridge.register('as.save', (params) async {
     final data = params; // 单参数已自动解包
   });
   ```

---

## 📚 补充：其他通信方式

除了 H5 调用 Flutter 的方法（使用 `as`），AppBridge 还支持其他通信场景：

### Flutter 调用 H5 方法

```dart
// Flutter 侧
final result = await bridge.invokeJs(
  'page.getState',  // H5 端注册的方法名
  {'key': 'value'}  // 可选参数
);
```

```javascript
// H5 侧注册
window.AppBridge.register('page.getState', async (params) => {
  return { ready: true, data: {...} }
})
```

### Flutter 发送事件给 H5

```dart
// Flutter 侧发送事件
bridge.emitEventToJs('app.ready', {
  'timestamp': DateTime.now().millisecondsSinceEpoch
});
```

```javascript
// H5 侧监听事件
window.AppBridge.on("app.ready", (payload) => {
  console.log("应用已准备:", payload);
});
```

### H5 发送事件给 Flutter

```javascript
// H5 侧发送事件
window.AppBridge.emit("page.stateChanged", {
  state: "ready",
});
```

```dart
// Flutter 侧监听事件
bridge.onEvent('page.stateChanged', (params) {
  print('页面状态改变: $params');
});
```

---

## 🐛 调试技巧

### H5 侧调试

```javascript
// 方法1：直接 console.log
try {
  const result = await window.as.someMethod();
  console.log("调用成功：", result);
} catch (error) {
  console.error("调用失败：", error.message);
}

// 方法2：查看可用方法
const capabilities = await window.as.getCapabilities();
console.log("可用方法：", capabilities.methods);

// 方法3：监听所有事件（调试用）
window.AppBridge.on("*", (event) => {
  console.log("收到事件：", event);
});
```

### Flutter 侧调试

```dart
// 所有调用都会自动打印日志
// 使用 flutter logs 或 Android Studio/Xcode 控制台查看

// 示例输出：
// [AppBridge] Received call: as.getInfo, params: null
// [AppBridge] Method as.getInfo completed successfully
```

---

## ❓ 常见问题

### Q1: 如何知道有哪些可用的方法？

**A**: 调用 `as.getCapabilities()` 获取完整列表。

```javascript
const capabilities = await window.as.getCapabilities();
console.log(capabilities.methods); // 所有方法名
console.log(capabilities.version); // AppBridge 版本
```

### Q2: 方法调用超时怎么办？

**A**: 默认超时为 10 秒。如果方法执行时间较长，可以在 Flutter 侧调用 H5 方法时自定义超时：

```dart
final result = await bridge.invokeJs(
  'page.heavyOperation',
  null,
  Duration(seconds: 30)  // 自定义超时时间
);
```

对于 H5 调用 Flutter（使用 `as`），超时时间固定为 10 秒。

### Q3: 如何传递文件数据？

**A**: 使用 Base64 编码：

```javascript
// H5 侧：将文件转换为 Base64
const fileToBase64 = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
};

const base64Data = await fileToBase64(file);
await window.as.uploadFileData(base64Data, file.name);
```

```dart
// Flutter 侧：解码 Base64
bridge.register('as.uploadFileData', (params) async {
  final base64 = params[0];
  final fileName = params[1];

  // 移除 data:xxx;base64, 前缀
  final base64Clean = base64.split(',').last;
  final bytes = base64Decode(base64Clean);

  // 保存文件
  await File('/path/$fileName').writeAsBytes(bytes);

  return {'success': true};
});
```

### Q4: TypeScript 中如何获得类型提示？

**A**: 创建类型定义文件：

```typescript
// types/app-bridge.d.ts
declare global {
  interface Window {
    as: {
      // 内置方法
      getCapabilities(): Promise<{
        version: string;
        methods: string[];
      }>;
      getInfo(): Promise<any>;
      selectFile(options?: {
        type?: "image" | "video" | "any";
        multiple?: boolean;
        extensions?: string[];
      }): Promise<any>;
      downloadBlob(data: {
        base64: string;
        filename: string;
        mimeType?: string;
      }): Promise<void>;
      saveProtocol(data: string | object): Promise<any>;

      // 自定义方法
      [key: string]: (...args: any[]) => Promise<any>;
    };

    AppBridge: {
      invoke(method: string, params?: any): Promise<any>;
      register(method: string, handler: (params?: any) => Promise<any>): void;
      on(event: string, handler: (payload: any) => void): () => void;
      emit(event: string, params?: any): Promise<void>;
    };
  }
}

export {};
```

---

## 📝 总结

- **H5 调用 Flutter**：使用 `window.as.methodName(params)` ✨ **最常用**
- **Flutter 调用 H5**：使用 `bridge.invokeJs(method, params)`
- **事件通信**：使用 `emit` 和 `on` 进行双向事件传递
- **参数自动解包**：单参数调用时自动解包，简化代码
- **统一返回格式**：建议使用 `{success, data, error}` 格式
- **完善文档**：为每个方法添加 `description` 和 `paramsDescription`

**开始使用**：调用 `await window.as.getCapabilities()` 查看所有可用方法！
