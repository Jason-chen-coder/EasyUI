import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class EasyMarkdownDemo extends StatelessWidget {
  const EasyMarkdownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Easy Markdown'),
        p('Markdown渲染组件，支持常见的Markdown语法。'),
        p('例如：标题、段落、列表、链接、数学公式、图片、代码块等。'),
        WidgetHighlight(
          builder: (context) {
            return EasyMarkdown(
              text: '''
# I'm h1
## I'm h2
### I'm h3
#### I'm h4
##### I'm h5
###### I'm h6

```Dart
class MarkdownHelper {


  Map<String, Widget> getTitleWidget(m.Node node) => title.getTitleWidget(node);

  Widget getPWidget(m.Element node) => p.getPWidget(node);

  Widget getPreWidget(m.Node node) => pre.getPreWidget(node);

}
```


*italic text*

**strong text**

`I'm code`

~~del~~

***~~italic strong and del~~***

> Test for blockquote and **strong**


- ul list
- one
    - aa *a* a
    - bbbb
        - CCCC

1. ol list
2. aaaa
3. bbbb
    1. AAAA
    2. BBBB
    3. CCCC


[I'm link](https://pub.dev)


- [ ] I'm *CheckBox*

- [x] I'm *CheckBox* too

Test for divider(hr):

---

Test for Table:

header 1 | header 2
---|---
row 1 col 1 | row 1 col 2
row 2 col 1 | row 2 col 2

Test for inline math:

- \$x + y\$
- \$x - y\$
- \$x \\times y\$
- \$x \\div y\$
- \$\\dfrac{x}{y}\$
- \$\\sqrt{x}\$

Test for block math:

\$\$\\lim_{x \\to 0^+} \\dfrac{1}{x} = \\infty\$\$

Image:

![support](assets/images/avatar.png)

Image with link:

[![pub package](assets/images/app_icon.png)](https://flutter.dev)

Html Image:

<img width="250" height="250" src="assets/images/custom_empty.png"/>

''',
            );
          },
          codeSnippet: '''
```dart
EasyMarkdown(
  text: '', // 输入你的Markdown文本
);
```
''',
        ),
      ],
    );
  }
}
