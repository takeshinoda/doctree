= class ThreadGroup < Object

[[c:Thread]] はグループを持ち、必ずいずれかのグループに属します。
ThreadGroup クラスによりグループに属する Thread をまとめて
操作することができます。

デフォルトの ThreadGroup は、
[[m:ThreadGroup::Default]] です。生成されたばかり
の [[c:Thread]] は生成した [[c:Thread]] のグループを引き継ぎます。

: 例:

生成したすべてのThreadが終了するのを待つ

    5.times {
       Thread.new { sleep 1; puts "#{Thread.current} finished" }
    }
    
    (ThreadGroup::Default.list - [Thread.current]).each {|th| th.join}
    
    puts "all threads finished"

対象の Thread が Thread を起こす可能性がある場合
([[m:Thread.exclusive]]参照)

    Thread.exclusive do
      (ThreadGroup::Default.list - [Thread.current]).each {|th| th.join}
    end

== Class Methods

--- new

新たな ThreadGroup を生成して返します。

== Instance Methods

--- add(thread)

スレッド thread のグループを self にします。

self を返します。

#@since 1.8.0
--- enclose

ThreadGroup への Thread の追加/削除を(freeze せずに)禁止します。
(追加/削除を行うと例外 [[c:ThreadError]] が発生します)

self を返します。

追加の例:

  thg = ThreadGroup.new.enclose
  thg.add Thread.new {}

  => -:2:in `add': can't move to the enclosed thread group (ThreadError)

削除の例:

  thg1 = ThreadGroup.new
  thg2 = ThreadGroup.new

  th = Thread.new {sleep 1}

  thg1.add th
  thg1.enclose
  thg2.add th

  => -:8:in `add': can't move from the enclosed thread group (ThreadError)
#@end

#@since 1.8.0
--- enclosed?

[[m:ThreadGroup#enclose]] の状態を真偽値で返します。
freeze された ThreadGroup に Thread の追加/削除はできなくなりますが、
enclosed? は false を返します。

    thg = ThreadGroup.new
    p thg.enclosed?         # => false
    thg.enclose
    p thg.enclosed?         # => true

    thg = ThreadGroup.new
    p thg.enclosed?         # => false
    thg.freeze
    p thg.enclosed?         # => false
#@end
--- list

self に属するスレッドの配列を返します。
#@since 1.8.0
version 1.8 では、aborting 状態であるスレッド
も要素に含まれます。つまり「生きている」スレッドの配列を返します。
#@else
終了処理中(aborting)、や終了状態(dead)であるスレッドは要素に含まれ
ません([[m:Thread.list]]と同じです)。
#@end

== Constants

--- Default

デフォルトで定義されている ThreadGroup です。メインスレッド
は最初このグループに属します。
