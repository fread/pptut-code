.class public pp/jasmin/Shortcut
.super java/lang/Object
.method public <init>()V
    aload_0
    invokespecial java/lang/Object/<init>()V
    return
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 5
    .limit locals 10

    new pp/jasmin/Shortcut
    dup
    invokespecial pp/jasmin/Shortcut/<init>()V
    ldc 1
    ldc 2
    ldc 0
    invokevirtual pp/jasmin/Shortcut/foo(III)V ; call void foo(int a,int x,int c)
                                              ; with a==1,x==2,c==0
    return
.end method


.method public foo(III)V
    .limit stack 5
    .limit locals 100

	iload_1
	iload_3
	if_icmpgt target_true

	iload_3
	ldc 0
	if_icmpgt target_true
	goto target_false

target_true:
	iload_1

	aload 0

	iload_1
	iload_2
	ldc 1
	isub
	imul
	iload_3
	iadd

	invokevirtual pp/jasmin/Shortcut/f(I)I

	isub
	istore 1

target_false:

    getstatic java/lang/System/out Ljava/io/PrintStream
    iload_1
    invokevirtual java/io/PrintStream/println(I)V   ; print x

    return
.end method

.method public f(I)I
	iload_1
	ireturn
	.limit stack 10
	.limit locals 10
.end method
