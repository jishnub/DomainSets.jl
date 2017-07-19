# productspace.jl

"""
By convention a geometric space with a tuple type `T` represents a product space
of the individual entries of `T`.
"""
const ProductSpace{T <: Tuple} = GeometricSpace{T}

# A `tensorproduct(a)` with just a single element returns `a`.
# tensorproduct(a::GeometricSpace) = tensorproduct(typeof(a))
tensorproduct(a::GeometricSpace, b::GeometricSpace) = tensorproduct(typeof(a), typeof(b))()
tensorproduct(a::GeometricSpace, b::GeometricSpace, c::GeometricSpace) = tensorproduct(typeof(a), typeof(b), typeof(c))()
tensorproduct(a::GeometricSpace, b::GeometricSpace, c::GeometricSpace, d::GeometricSpace) = tensorproduct(typeof(a), typeof(b), typeof(c), typeof(d))()

# A `tensorproduct(a)` with just a single element returns `a`.
# tensorproduct(::Type{GeometricSpace{T}}) where {T} = ProductSpace{Tuple{T}}
tensorproduct(::Type{GeometricSpace{T}}, ::Type{GeometricSpace{S}}) where {T,S} = ProductSpace{Tuple{T,S}}
tensorproduct(::Type{GeometricSpace{T}}, ::Type{GeometricSpace{S}}, ::Type{GeometricSpace{U}}) where {T,S,U} = ProductSpace{Tuple{T,S,U}}
tensorproduct(::Type{GeometricSpace{T}}, ::Type{GeometricSpace{S}}, ::Type{GeometricSpace{U}}, ::Type{GeometricSpace{V}}) where {T,S,U,V} = ProductSpace{Tuple{T,S,U,V}}

# A `tensorproduct(a)` with just a single element returns `a`.
# zero(::Type{ProductSpace{Tuple{T}}}) where {T} = (zero(T),)
zero(::Type{ProductSpace{Tuple{T,S}}}) where {T,S} = (zero(T), zero(S))
zero(::Type{ProductSpace{Tuple{T,S,U}}}) where {T,S,U} = (zero(T), zero(S), zero(U))
zero(::Type{ProductSpace{Tuple{T,S,U,V}}}) where {T,S,U,V} = (zero(T), zero(S), zero(U), zero(V))


## Isomorphisms

# # Due to #22239, we temporarily disable this isomorphism
# # We identity (T,[T,T]) with [T,T,T]

## isomorphism_reduction(::Type{VectorSpace{3,T}}, ::Type{ProductSpace{Tuple{S,SVector{2,S}}}}) where {T,S} =
##     (GeometricSpace{T}, GeometricSpace{S})

## convert_space(::Type{ProductSpace{Tuple{T,SVector{2,T}}}}, x::SVector{3,T}) where {T} = (x[1], SVector{2,T}(x[2],x[3]))
## convert_space(::Type{VectorSpace{3,T}}, x::Tuple{T,SVector{2,T}}) where {T} = SVector{3,T}(x[1], x[2][1], x[2][2])

# We identity ((T,T),T) with [T,T,T]

isomorphism_reduction(::Type{VectorSpace{3,T}}, ::Type{ProductSpace{Tuple{Tuple{S,S},S}}}) where {T,S} =
    (GeometricSpace{T}, GeometricSpace{S})

convert_space(::Type{ProductSpace{Tuple{Tuple{T,T},T}}}, x::SVector{3,T}) where {T} = ((x[1], x[2]), x[3])
convert_space(::Type{VectorSpace{3,T}}, x::Tuple{Tuple{T,T},T}) where {T} = SVector{3,T}(x[1][1], x[1][2], x[2])

# # Due to #22239, we temporarily disable this isomorphism
# # We identity (T,(T,T)) with [T,T,T]
#
# isomorphism_reduction(::Type{VectorSpace{3,T}}, ::Type{ProductSpace{Tuple{S,Tuple{S,S}}}}) where {T,S} =
#     (GeometricSpace{T}, GeometricSpace{S})
#
# convert_space(::Type{ProductSpace{Tuple{T,Tuple{T,T}}}}, x::SVector{3,T}) where {T} = (x[1], (x[2],x[3]))
# convert_space(::Type{VectorSpace{3,T}}, x::Tuple{T,Tuple{T,T}}) where {T} = SVector{3,T}(x[1], x[2][1], x[2][2])
#
# # Due to #22239, we temporarily disable this isomorphism
# # We identity ([T,T],T) with [T,T,T]
#
isomorphism_reduction(::Type{VectorSpace{3,T}}, ::Type{ProductSpace{Tuple{SVector{2,S},S}}}) where {T,S} =
    (GeometricSpace{T}, GeometricSpace{S})

convert_space(::Type{ProductSpace{Tuple{SVector{2,T},T}}}, x::SVector{3,T}) where {T} = (SVector{2,T}(x[1], x[2]), x[3])
convert_space(::Type{VectorSpace{3,T}}, x::Tuple{SVector{2,T},T}) where {T} = SVector{3,T}(x[1][1], x[1][2], x[2])

# We can identify a product space with equal types with a vector space of the
# same dimension and type. The agreement is between NTuple{N,T} and SVector{N,T}.

isomorphism_reduction(::Type{VectorSpace{N,T}}, ::Type{ProductSpace{NTuple{N,S}}}) where {N,T,S} =
    (GeometricSpace{T}, GeometricSpace{S})

convert_space(::Type{ProductSpace{NTuple{N,T}}}, x::SVector{N,T}) where {N,T} = Tuple(x)
convert_space(::Type{VectorSpace{N,T}}, x::NTuple{N,T}) where {N,T} = SVector{N,T}(x)
