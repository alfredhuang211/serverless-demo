˙x
˝
9
Add
x"T
y"T
z"T"
Ttype:
2	

ApplyGradientDescent
var"T

alpha"T

delta"T
out"T"
Ttype:
2	"
use_lockingbool( 

ArgMax

input"T
	dimension"Tidx
output"output_type"
Ttype:
2	"
Tidxtype0:
2	"
output_typetype0	:
2	
x
Assign
ref"T

value"T

output_ref"T"	
Ttype"
validate_shapebool("
use_lockingbool(
R
BroadcastGradientArgs
s0"T
s1"T
r0"T
r1"T"
Ttype0:
2	
8
Cast	
x"SrcT	
y"DstT"
SrcTtype"
DstTtype
8
Const
output"dtype"
valuetensor"
dtypetype
A
Equal
x"T
y"T
z
"
Ttype:
2	

4
Fill
dims

value"T
output"T"	
Ttype
.
Identity

input"T
output"T"	
Ttype
+
Log
x"T
y"T"
Ttype:	
2
o
MatMul
a"T
b"T
product"T"
transpose_abool( "
transpose_bbool( "
Ttype:

2

Mean

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( "
Ttype:
2	"
Tidxtype0:
2	
e
MergeV2Checkpoints
checkpoint_prefixes
destination_prefix"
delete_old_dirsbool(
<
Mul
x"T
y"T
z"T"
Ttype:
2	
-
Neg
x"T
y"T"
Ttype:
	2	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
4

Reciprocal
x"T
y"T"
Ttype:
	2	
[
Reshape
tensor"T
shape"Tshape
output"T"	
Ttype"
Tshapetype0:
2	
o
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
P
Shape

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
H
ShardedFilename
basename	
shard

num_shards
filename
8
Softmax
logits"T
softmax"T"
Ttype:
2
N

StringJoin
inputs*N

output"
Nint(0"
	separatorstring 
9
Sub
x"T
y"T
z"T"
Ttype:
2	

Sum

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( "
Ttype:
2	"
Tidxtype0:
2	
c
Tile

input"T
	multiples"
Tmultiples
output"T"	
Ttype"

Tmultiplestype0:
2	
s

VariableV2
ref"dtype"
shapeshape"
dtypetype"
	containerstring "
shared_namestring "serve*1.4.12v1.4.0-19-ga52c8d9ťa
f
xPlaceholder*
dtype0*(
_output_shapes
:˙˙˙˙˙˙˙˙˙*
shape:˙˙˙˙˙˙˙˙˙
\
zerosConst*
valueB	
*    *
dtype0*
_output_shapes
:	

~
Variable
VariableV2*
shared_name *
dtype0*
_output_shapes
:	
*
	container *
shape:	


Variable/AssignAssignVariablezeros*
use_locking(*
T0*
_class
loc:@Variable*
validate_shape(*
_output_shapes
:	

j
Variable/readIdentityVariable*
T0*
_class
loc:@Variable*
_output_shapes
:	

T
zeros_1Const*
valueB
*    *
dtype0*
_output_shapes
:

v

Variable_1
VariableV2*
dtype0*
_output_shapes
:
*
	container *
shape:
*
shared_name 

Variable_1/AssignAssign
Variable_1zeros_1*
_class
loc:@Variable_1*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0
k
Variable_1/readIdentity
Variable_1*
_output_shapes
:
*
T0*
_class
loc:@Variable_1
z
MatMulMatMulxVariable/read*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
transpose_a( *
transpose_b( 
U
addAddMatMulVariable_1/read*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

C
ySoftmaxadd*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0
n
PlaceholderPlaceholder*
dtype0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
shape:˙˙˙˙˙˙˙˙˙

?
LogLogy*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

N
mulMulPlaceholderLog*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

V
ConstConst*
dtype0*
_output_shapes
:*
valueB"       
T
SumSummulConst*

Tidx0*
	keep_dims( *
T0*
_output_shapes
: 
0
NegNegSum*
T0*
_output_shapes
: 
R
gradients/ShapeConst*
valueB *
dtype0*
_output_shapes
: 
T
gradients/ConstConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 
Y
gradients/FillFillgradients/Shapegradients/Const*
T0*
_output_shapes
: 
N
gradients/Neg_grad/NegNeggradients/Fill*
T0*
_output_shapes
: 
q
 gradients/Sum_grad/Reshape/shapeConst*
valueB"      *
dtype0*
_output_shapes
:

gradients/Sum_grad/ReshapeReshapegradients/Neg_grad/Neg gradients/Sum_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes

:
[
gradients/Sum_grad/ShapeShapemul*
T0*
out_type0*
_output_shapes
:

gradients/Sum_grad/TileTilegradients/Sum_grad/Reshapegradients/Sum_grad/Shape*

Tmultiples0*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

c
gradients/mul_grad/ShapeShapePlaceholder*
T0*
out_type0*
_output_shapes
:
]
gradients/mul_grad/Shape_1ShapeLog*
T0*
out_type0*
_output_shapes
:
´
(gradients/mul_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/mul_grad/Shapegradients/mul_grad/Shape_1*2
_output_shapes 
:˙˙˙˙˙˙˙˙˙:˙˙˙˙˙˙˙˙˙*
T0
m
gradients/mul_grad/mulMulgradients/Sum_grad/TileLog*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙


gradients/mul_grad/SumSumgradients/mul_grad/mul(gradients/mul_grad/BroadcastGradientArgs*

Tidx0*
	keep_dims( *
T0*
_output_shapes
:

gradients/mul_grad/ReshapeReshapegradients/mul_grad/Sumgradients/mul_grad/Shape*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0*
Tshape0
w
gradients/mul_grad/mul_1MulPlaceholdergradients/Sum_grad/Tile*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0
Ľ
gradients/mul_grad/Sum_1Sumgradients/mul_grad/mul_1*gradients/mul_grad/BroadcastGradientArgs:1*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0

gradients/mul_grad/Reshape_1Reshapegradients/mul_grad/Sum_1gradients/mul_grad/Shape_1*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0*
Tshape0
g
#gradients/mul_grad/tuple/group_depsNoOp^gradients/mul_grad/Reshape^gradients/mul_grad/Reshape_1
Ú
+gradients/mul_grad/tuple/control_dependencyIdentitygradients/mul_grad/Reshape$^gradients/mul_grad/tuple/group_deps*
T0*-
_class#
!loc:@gradients/mul_grad/Reshape*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

ŕ
-gradients/mul_grad/tuple/control_dependency_1Identitygradients/mul_grad/Reshape_1$^gradients/mul_grad/tuple/group_deps*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0*/
_class%
#!loc:@gradients/mul_grad/Reshape_1

gradients/Log_grad/Reciprocal
Reciprocaly.^gradients/mul_grad/tuple/control_dependency_1*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0

gradients/Log_grad/mulMul-gradients/mul_grad/tuple/control_dependency_1gradients/Log_grad/Reciprocal*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

h
gradients/y_grad/mulMulgradients/Log_grad/muly*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

p
&gradients/y_grad/Sum/reduction_indicesConst*
_output_shapes
:*
valueB:*
dtype0
¤
gradients/y_grad/SumSumgradients/y_grad/mul&gradients/y_grad/Sum/reduction_indices*#
_output_shapes
:˙˙˙˙˙˙˙˙˙*

Tidx0*
	keep_dims( *
T0
o
gradients/y_grad/Reshape/shapeConst*
valueB"˙˙˙˙   *
dtype0*
_output_shapes
:

gradients/y_grad/ReshapeReshapegradients/y_grad/Sumgradients/y_grad/Reshape/shape*
T0*
Tshape0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

gradients/y_grad/subSubgradients/Log_grad/mulgradients/y_grad/Reshape*'
_output_shapes
:˙˙˙˙˙˙˙˙˙
*
T0
h
gradients/y_grad/mul_1Mulgradients/y_grad/suby*
T0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

^
gradients/add_grad/ShapeShapeMatMul*
_output_shapes
:*
T0*
out_type0
d
gradients/add_grad/Shape_1Const*
valueB:
*
dtype0*
_output_shapes
:
´
(gradients/add_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/add_grad/Shapegradients/add_grad/Shape_1*
T0*2
_output_shapes 
:˙˙˙˙˙˙˙˙˙:˙˙˙˙˙˙˙˙˙

gradients/add_grad/SumSumgradients/y_grad/mul_1(gradients/add_grad/BroadcastGradientArgs*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0

gradients/add_grad/ReshapeReshapegradients/add_grad/Sumgradients/add_grad/Shape*
T0*
Tshape0*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

Ł
gradients/add_grad/Sum_1Sumgradients/y_grad/mul_1*gradients/add_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/add_grad/Reshape_1Reshapegradients/add_grad/Sum_1gradients/add_grad/Shape_1*
_output_shapes
:
*
T0*
Tshape0
g
#gradients/add_grad/tuple/group_depsNoOp^gradients/add_grad/Reshape^gradients/add_grad/Reshape_1
Ú
+gradients/add_grad/tuple/control_dependencyIdentitygradients/add_grad/Reshape$^gradients/add_grad/tuple/group_deps*
T0*-
_class#
!loc:@gradients/add_grad/Reshape*'
_output_shapes
:˙˙˙˙˙˙˙˙˙

Ó
-gradients/add_grad/tuple/control_dependency_1Identitygradients/add_grad/Reshape_1$^gradients/add_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/add_grad/Reshape_1*
_output_shapes
:

ť
gradients/MatMul_grad/MatMulMatMul+gradients/add_grad/tuple/control_dependencyVariable/read*(
_output_shapes
:˙˙˙˙˙˙˙˙˙*
transpose_a( *
transpose_b(*
T0
¨
gradients/MatMul_grad/MatMul_1MatMulx+gradients/add_grad/tuple/control_dependency*
T0*
_output_shapes
:	
*
transpose_a(*
transpose_b( 
n
&gradients/MatMul_grad/tuple/group_depsNoOp^gradients/MatMul_grad/MatMul^gradients/MatMul_grad/MatMul_1
ĺ
.gradients/MatMul_grad/tuple/control_dependencyIdentitygradients/MatMul_grad/MatMul'^gradients/MatMul_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/MatMul_grad/MatMul*(
_output_shapes
:˙˙˙˙˙˙˙˙˙
â
0gradients/MatMul_grad/tuple/control_dependency_1Identitygradients/MatMul_grad/MatMul_1'^gradients/MatMul_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_grad/MatMul_1*
_output_shapes
:	

b
GradientDescent/learning_rateConst*
_output_shapes
: *
valueB
 *
×#<*
dtype0

4GradientDescent/update_Variable/ApplyGradientDescentApplyGradientDescentVariableGradientDescent/learning_rate0gradients/MatMul_grad/tuple/control_dependency_1*
_output_shapes
:	
*
use_locking( *
T0*
_class
loc:@Variable
˙
6GradientDescent/update_Variable_1/ApplyGradientDescentApplyGradientDescent
Variable_1GradientDescent/learning_rate-gradients/add_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@Variable_1*
_output_shapes
:


GradientDescentNoOp5^GradientDescent/update_Variable/ApplyGradientDescent7^GradientDescent/update_Variable_1/ApplyGradientDescent
2
initNoOp^Variable/Assign^Variable_1/Assign
R
ArgMax/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
r
ArgMaxArgMaxyArgMax/dimension*
T0*
output_type0	*#
_output_shapes
:˙˙˙˙˙˙˙˙˙*

Tidx0
T
ArgMax_1/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 

ArgMax_1ArgMaxPlaceholderArgMax_1/dimension*
T0*
output_type0	*#
_output_shapes
:˙˙˙˙˙˙˙˙˙*

Tidx0
N
EqualEqualArgMaxArgMax_1*
T0	*#
_output_shapes
:˙˙˙˙˙˙˙˙˙
P
CastCastEqual*#
_output_shapes
:˙˙˙˙˙˙˙˙˙*

DstT0*

SrcT0

Q
Const_1Const*
valueB: *
dtype0*
_output_shapes
:
Y
MeanMeanCastConst_1*
_output_shapes
: *

Tidx0*
	keep_dims( *
T0
P

save/ConstConst*
valueB Bmodel*
dtype0*
_output_shapes
: 

save/StringJoin/inputs_1Const*<
value3B1 B+_temp_3da3087737f44ffeb4fbd569f0541ddd/part*
dtype0*
_output_shapes
: 
u
save/StringJoin
StringJoin
save/Constsave/StringJoin/inputs_1*
	separator *
N*
_output_shapes
: 
Q
save/num_shardsConst*
dtype0*
_output_shapes
: *
value	B :
\
save/ShardedFilename/shardConst*
value	B : *
dtype0*
_output_shapes
: 
}
save/ShardedFilenameShardedFilenamesave/StringJoinsave/ShardedFilename/shardsave/num_shards*
_output_shapes
: 
u
save/SaveV2/tensor_namesConst*
dtype0*
_output_shapes
:*)
value BBVariableB
Variable_1
g
save/SaveV2/shape_and_slicesConst*
_output_shapes
:*
valueBB B *
dtype0

save/SaveV2SaveV2save/ShardedFilenamesave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesVariable
Variable_1*
dtypes
2

save/control_dependencyIdentitysave/ShardedFilename^save/SaveV2*'
_class
loc:@save/ShardedFilename*
_output_shapes
: *
T0

+save/MergeV2Checkpoints/checkpoint_prefixesPacksave/ShardedFilename^save/control_dependency*
T0*

axis *
N*
_output_shapes
:
}
save/MergeV2CheckpointsMergeV2Checkpoints+save/MergeV2Checkpoints/checkpoint_prefixes
save/Const*
delete_old_dirs(
z
save/IdentityIdentity
save/Const^save/control_dependency^save/MergeV2Checkpoints*
_output_shapes
: *
T0
l
save/RestoreV2/tensor_namesConst*
valueBBVariable*
dtype0*
_output_shapes
:
h
save/RestoreV2/shape_and_slicesConst*
valueB
B *
dtype0*
_output_shapes
:

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices*
_output_shapes
:*
dtypes
2

save/AssignAssignVariablesave/RestoreV2*
use_locking(*
T0*
_class
loc:@Variable*
validate_shape(*
_output_shapes
:	

p
save/RestoreV2_1/tensor_namesConst*
valueBB
Variable_1*
dtype0*
_output_shapes
:
j
!save/RestoreV2_1/shape_and_slicesConst*
valueB
B *
dtype0*
_output_shapes
:

save/RestoreV2_1	RestoreV2
save/Constsave/RestoreV2_1/tensor_names!save/RestoreV2_1/shape_and_slices*
_output_shapes
:*
dtypes
2
˘
save/Assign_1Assign
Variable_1save/RestoreV2_1*
use_locking(*
T0*
_class
loc:@Variable_1*
validate_shape(*
_output_shapes
:

8
save/restore_shardNoOp^save/Assign^save/Assign_1
-
save/restore_allNoOp^save/restore_shard"<
save/Const:0save/Identity:0save/restore_all (5 @F8"
trainable_variables|z
7

Variable:0Variable/AssignVariable/read:02zeros:0
?
Variable_1:0Variable_1/AssignVariable_1/read:02	zeros_1:0"
train_op

GradientDescent"
	variables|z
7

Variable:0Variable/AssignVariable/read:02zeros:0
?
Variable_1:0Variable_1/AssignVariable_1/read:02	zeros_1:0