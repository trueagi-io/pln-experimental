# PLN Based Next Token Prediction

## Overview

Is next token prediction, what LLMs excel at, doable (in practice) by
PLN?  This is the question we will explore in this document.  But why
would one want to use PLN to do next token prediction in the first
place?  I believe there are several advantages:

1. Learning with PLN could be potentially far more sample efficient
   than with transformers.  Thus requiring a smaller corpus of text
   than traditionally used to obtain the same prediction accuracy.
2. Doing next token prediction could be a way to bypass Semantic
   Parsing (turning natural language into logic).  Basically,
   everything would be done in PLN, from semantic parsing, logical
   reasoning, to text generation (via next token prediction).
3. Since everything would be done with PLN it should be easier to add
   domain specific knowledge, either via prompting, then verifying
   that the correct logical knowledge has been implanted, or by
   formulating the knowledge directly in logic.  It would thus
   constitute an alternative to finetuning.
4. With PLN there is no clear separation between training and
   inference.  Everything could happen online.  Whenever a prompt is
   entered it is simultaneously part of the short term context and the
   longer term corpus.
5. No need to limit carrying the thinking phase (for reasoning LLMs
   like deepseek-r1) in natural language.  PLN could carry the
   thinking at whichever level of abstraction it choses to.

But there are also disadvantages:

1. PLN potentially requires far more computational resources than
   transformers do.
2. To have any hope of it working at all, would require excellent,
   practical, sophisticated attentional allocation and inference
   control mechanisms.  This is both a disadvantage and an advantage,
   because, in principle, such attentional allocation and inference
   control mechanisms could in fact outperform transformers, possibly
   dramatically, especially for training, but also for inference.

## Experimental Setup

### Tokenization

Maybe tokenization could ultimately be carried out by PLN itself but
for starter I suggest to do it as a pre-processing step as it is
usually done.  At the end of the tokenization process we should obtain
a list of tokens alongside their frequencies, as is traditionally the
case, and their counts, as is not so traditionally the case.  The
counts are going to be important for PLN.

### Representing Next Token Prediction Task

Once the tokens and their frequencies have been established the next
question is how to represent the token prediction task.  One may
legitimately ask whether the task should take place in "token space"
or in "embedding space".  Ideally I think it should take place in
token space and leave to PLN to create whatever embedding space, or
substitute thereof, happens to emerge from reasoning.  But one could
also try to mimick more closely transformers and pre-build a PLN-ized
version of an embedding space.

In any case, we provide two ways to formulate the token prediction
task.

#### Using NextToken Predicate

Define a probabilistic categorical predicate `NextToken` with the
following type signature:

```
NextToken : (List Token) -> 𝛺 -> Token
```

Note the curried representation.  The probabilistic aspect of
`NextToken` is captured by the argument `𝛺`.  Explaining `𝛺` in detail
is beyond the scope of this document but can be found [here](TODO).

Calling `NextToken` a "categorical predicate" might be too much of a
linguistic stretch, so let me explain what I mean.  PLN traditionally
operates on (probabilistic) predicates, functions of Boolean codomain,
that is what justified using a Beta distribution as the underlying
second order distribution associated to a truth value.  The Token type
is not Boolean but categorical.  It could be represented by the
product of `N` predicates (where `N` is the logarithm of the
cardinality of `Token`), or, probably better, by upgrading PLN to
support categories.  I believe this should not be difficult.  The
underlying Beta distribution would be replaced by a Dirichlet
distribution and the various predicate operators, conjunction,
disjunctions, etc, would be generalized to work with categories.  The
following old but still relevant [Github issue](TODO) discusses such
generalization.

The PLN knowledge base would be initialized with the following
instances:

1. Marginal token probabilities

   ```
   (NextToken Nil) <TV₀>
   ```

   where `<TV₀>` represents the Dirichlet distribution built out of
   the frequencies and counts of the tokenization process.

2. Conditional probabilities obtained by sliding the context window
   over the corpus while varying the context window size from 1 to its
   maximum.

   ```
   (NextToken Ctxᵢ) <TVᵢ>
   ```

   where `i` is an index over all possible context windows.  Thus
   `Ctxᵢ` is the ith context and `<TVᵢ>` is the ith truth value
   obtained from the frequencies and counts of the tokens immediately
   following this context.  Of course, especially for large contexts,
   most tokens will have frequencies and counts of zero, which is
   perfectly fine.  Also, one may worry that the number of such
   instances is going to be enormous, and it is true, but no more
   enourmous than what LLMs are typically dealing with, and in fact
   probably smaller than what is usually used if PLN based token
   prediction delivers on its promise of sample efficiency.

#### Using IthToken Predicate

An alternate representation could be to use a probabilistic
categorical predicate that maps an index to a token, instead of a
context to a token.  Let us call this predicate `IthToken` to
represent the ith token in the corpus.  Its type signature would be

```
IthToken : Nat -> 𝛺 -> Token
```

where `Nat` is the set of indices of the corpus.  So if the corpus is

```
I· ·like· ·math
```

where `·` represents a token separator, then the intances making up
`IthToken` would be

```
(IthToken 0) <{I:1}>
(IthToken 1) <{ :1}>
(IthToken 2) <{like:1}>
(IthToken 3) <{ :1}>
(IthToken 4) <{math:1}>
```

where `<{I:1}>` represents a truth value corresponding to the
Dirichlet distribution obained from setting a count of 1 to token `I`,
and zero to everything else.

Then one could further fill the knowledge with the following:

1. Marginal token probabilities

   ```
   IthToken <TV₀>
   ```

   where `<TV₀>` would, just like for `(NextToken Nil)`, be built out
   of the frequencies and counts of the tokenization process.

2. Conditional probabilities over a context of length 1

   ```
   (IthToken /-1-> IthToken) <TV₁>
   ```

   where `/-1->` would be the predictive implication with a lead of 1,
   thus equivalent to the following regular implication

   ```
   (IthToken -> (Lead 1 IthToken)) <TV₁>
   ```

   capturing the conditional probability of a token coming next
   knowing the current token.  See [Temporal PLN](TODO) for more
   information.

2. Conditional probabilities over a context of length 2

   ```
   ((IthToken |1\ IthToken) /-1-> IthToken) <TV₂>
   ```

   where `|1\` is the sequential conjuction with a lag of 1, thus
   equivalent to regular implication

   ```
   (((Lag 1 IthToken) /\ IthToken) -> (Lead IthToken)) <TV₂>
   ```

   capturing the conditional probability of a token coming next
   knowing the current and previous tokens.

   And so on for all context windows sizes.

### Learning and Inference

Regardless of what initial representation is used, `NextToken` or
`IthToken`, the fun, so does the troubles, really starts when PLN is
let free to discover predictive patterns and use them for predictive
inferences.  What happens from here is where the research begin.
Reasoning may involve a mixture of foward chaining, to infere whatever
knowledge can be derived from the existing knowledge, combined with
backward chaining given as query the truth value, representing a
Dirichlet distribution over `Token`, of the next token given a
context.  The next token would then be selected by applying Thompson
sampling over the inferred truth value.
