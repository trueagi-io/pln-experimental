# PLN Based Surprisingness

How to calculate the surprisingness of a pattern, in general and in
the context of pattern mining in particular, using PLN inference?
This is the question that will be attempted to be answered in this
document.

## Surprisingness in the Context of PLN

What is surprising?  I suppose most would agree with the following
informal definition:

"Something is surprising when it is deviates from expectation."

In the context of PLN reasoning, and pattern mining in particular, the
expectation of something is measured by the truth value over its
corresponding PLN statement.

For example, let us assume we are given to observe a certain predicate

```
P : Nat -> Bool
```

over a finite set of natural numbers.  The observations are

```
(P 0) ≞ <1 1>
(P 1) ≞ <0 1>
(P 2) ≞ <1 1>
(P 3) ≞ <0 1>
(P 4) ≞ <1 1>
(P 5) ≞ <0 1>
```

Indicating that `(P 0)` has a truth value `<1 1>` of evaluating to
true, `(P 1)` has a truth value `<0 1>` of evaluating to true, or
equivalenty has a truth value `<1 1>` of evaluating to false, etc.  A
bit of reasoning may lead to infer that `P` likely corresponds to the
evenness of natural numbers, that is, it is true for natural numbers
that are divisible by 2 and false otherwise.  A subsequent PLN
reasoning may thus assign a high truth value to `(P 6)`, because it is
even.  The truth value could be for instance `<0.9 0.6>` (I'm just
making a truth value up).  Let us assume a new observation of `P` is
provided

```
(P 6) ≞ <0 1>
```

This observation contradicts what was previously inferred

```
(P 6) ≞ <0.9 0.6>
```

This high difference of truth values coincides with what we may want
to call surprisingness.

## Surprisingness in the Context of Pattern Mining

In the context of pattern mining, the same idea may apply.  A pattern
may be surprising if its empirical truth value is different than what
is expected.  For instance, let us consider the two predicates `P` and
`Q` over natural numbers, with observations

```
(P 0) ≞ <1 1>
(P 1) ≞ <1 1>
(P 2) ≞ <1 1>
(P 3) ≞ <0 1>
(P 4) ≞ <0 1>
(P 5) ≞ <0 1>
```

and

```
(Q 0) ≞ <0 1>
(Q 1) ≞ <0 1>
(Q 2) ≞ <0 1>
(Q 3) ≞ <1 1>
(Q 4) ≞ <1 1>
(Q 5) ≞ <1 1>
```

The truth values of `P` and `Q` are thus empirically

```
P ≞ <0.5 0.86>
Q ≞ <0.5 0.86>
```

The strength 0.5 comes from the fact that they are both evaluate to
true and false to an equal amount, specifically

```
0.5 = 3/6
```

where 3 is the number of observed evaluations to true (a.k.a. positive
evidence) and 6 is the total number of observations.  The confidence
0.86 comes from the formula `confidence = N / (N + 1)` where `N` is
the total number of observations, thus

```
0.86 ≈ 6/(6+1)
```

Let us say we wish to infer the truth value over the conjunction of
`P` and `Q`.  We can do that in at least two ways

1. Using a Conjunction Introduction rule

```
P ≞ TV1
Q ≞ TV2
|-
(∧ P Q) ≞ TV
```

where TV is obtain with a certain formula.  This rule may assume for
instance that `P` and `Q` are independent, resulting in

```
(∧ P Q) ≞ <0.25 0.6>
```

where 0.25 would have been obtained by multipling the strengths of
`TV1` and `TV2`

```
0.25 = 0.5 * 0.5
```

and 0.6 would have been obtained in a certain way that we do not need
to explain yet (and frankly, I don't even precisely know how it would
be calculated).

So that is the first way to calculate the truth value of `(∧ P Q)`,
let see the second.

2. Using induction, i.e. via using direct observations.  To do that,
first we infer the truth value of the application of

```
(∧ P Q)
```

over each natural number where `P` and `Q` where previously observed,
we find

```
((∧ P Q) 0) ≞ <0 1>
((∧ P Q) 1) ≞ <0 1>
((∧ P Q) 2) ≞ <0 1>
((∧ P Q) 3) ≞ <0 1>
((∧ P Q) 4) ≞ <0 1>
((∧ P Q) 5) ≞ <0 1>
```

Meaning they all evaluate to false.  We can then infer the truth value
of `(∧ P Q)` empirically using induction, which gives us

```
(∧ P Q) ≞ <0 0.86>
```

The difference between `<0 0.86>` and `<0.25 0.6>` is once again a
possible measure of surprisingness.

## Surprisingness as the Difference between Truth Values

In general we could consider that the surprisingness of something is
the difference in truth values obtained between different reasoning
paths, although in practice it is useful to restrict this to the
difference between a truth value obtained empirically and a truth
value obtained non-empirically.  This specific way of measuring
surprisingness has a practical advantage.  If there is an important
difference between a truth value obtained empirically and
non-empirically, it indicates that the world is not completely
understood, and therefore surprising patterns must be given extra
attention (have for instance long term importance) because they carry
information that could not be derived from existing knowledge.

For instance, reusing the example of `P` and `Q` above, let us assume
that the system has a prior knowledge that `P` and `Q` are dissimilar

```
(⟺ P Q) ≞ <0 0.9>
```

Then another reasoning path than the mere application of conjunction
introduction (maybe involving deduction) may lead to

```
(∧ P Q) ≞ <0 0.7>
```

where the truth value has been set to `<0 0.7>` as a conceivable
possible result, just to give an idea.  Even after merging this truth
value and the truth value obtained from conjunction introduction, let
say

```
(∧ P Q) ≞ <0.1 0.65>
```

Again this is not precisely calculated and it is given just to give an
idea of what we may obtain.  The difference between

```
<0 0.86>
```

the truth value of `(∧ P Q)` that has been obtain empirically, and

```
<0.1 0.65>
```

the truth value that has been obtained non-empirically using the
knowledge that `P` and `Q` are dissimilar, is much lower than the
difference between

```
<0 0.86>
```

and

```
<0.25 0.6>
```

the truth value has been octained non-empirically disregarding the
assumption that `P` and `Q` are dissimilar.  In other words, in this
example, taking into consideration the prior knowledge that `P` and
`Q` are dissimilar makes `(∧ P Q)` far less surprising, its empirical
truth value is expected.

So it seems that a good definition of surprisingness of a particular
predicate (including composite predicates like `(∧ P Q)`) would be

"Difference between truth value inferred empirically and truth value
inferred non-empirically."

## Empirical vs Non-empirical Inference

The difference between empirical and non-empirical inference remains
to be clearly defined.  Maybe it suffices to say that a truth value
inferred empirically must involve induction, while a truth value
inferred non-empirically must exclude induction.  It is not clear what
would be the role of abduction.  I suppose it may come down to what is
considered empirical.

Also, it should be clear that the notion of empirical and
non-empirical are relative to a current state of knowledge.  Indeed,
ultimately every inferred truth value is going to empirical at some
point.  But an inference would be considered empirical if it involves
additional induction compared to what was previously used in order to
obtain the current knowledge base.  For instance, to build a knowledge
base containing

```
P ≞ <0.5 0.86>
Q ≞ <0.5 0.86>
```

induction used to obtain the truth values of `P` and `Q`, but once it
is known, further inferrence on `(∧ P Q)` will be considered empirical
if it involves additional induction.  If it does not involve
additional induction, by using for example conjunction introduction
between `P` and `Q`, then it will be considered non-empirical.

## Measuring the Difference between Truth Values

How to measure the difference between truth values?  There are many
possibilities.  It would be nice if such calculation could be mapped
back into existing PLN rules.  But regardless, it should capture the
difference between their underlying second order distributions, as
these are carrying the notion of expectation.  Thus a measure of
difference between probabilistic distributions may be suitable, such
as the Jensen-Shannon divergence, among others.

## From Pattern to Predicate

I have been using predicates in the examples so far, but the idea
applies equally well to patterns that have been mined.  In fact a
pattern can be viewed as a predicate that takes one or more grounded
atoms as inputs and outputs true iff it matches the said pattern.

For instance the predicate corresponding to pattern

```
(, (→ $A $B) (→ $B $C))
```

could be formulated as:

```
(= (Transitive $x $y)
   (case (, $x $y)
     (((, (→ $A $B) (→ $B $C)) True)
      ($otherwise False))))
```

in MeTTa.  Thus the predicate `Transitive` takes two atoms and outputs
True if they match the pattern, False otherwise.  The definition of
`Transitive` could also be adjusted to take into account the
commutativity of `,`:

```
(= (Transitive $x $y)
   (case (, $x $y)
     (((, (→ $A $B) (→ $B $C)) True)
      ((, (→ $B $C) (→ $A $B)) True)
      ($otherwise False))))
```

Thus one can see that reasoning about predicates using PLN amounts to
reasoning about patterns.  If it is too verbose to convert a pattern
into a predicate, one could use a higher order function that does that
automatically, thus `Transitive` would merely be defined as

```
(PatternToPredicate (, (→ $A $B) (→ $B $C)))
```

Alternatively maybe PLN could be updated to reason about patterns
directly, but in the end it is probably equivalent to using a higher
order function to convert pattern into predicate.
