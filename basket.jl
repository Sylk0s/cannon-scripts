# For some reason packages are just broken on my pc
# include("Explosion.jl")
# import .Explosion.explosion

# TODO list:
# include calculations for additional dy from t3
# include eyeheights and such

expheight = 0.061250001192092896 
top_hitbox = 3/32 # r

ΔT3 = 0.00004 # r

ΔB2 = .3449652888499912 
max = round(100/ΔB2)
min = round(8/ΔB2)

struct Alignment
    count # count of B2 tnt for each alignment
    offset # offset from the desired height
    height # velocity of alignment FROM B1
    adj_count # tnt count for upwards adjustment
    adj_offset # adjusted offset from desired height (should be positive)
    adj_height # new adjusted y height
end

alignments = []

# Algorithm:
# 1) Find the closest alignments with no adjustments
# 2) search through the closer alignments for an adjustment
# 3) Order and display based on minimum tnt counts

for c ∈ min:max
    # needs to go as close as possible to an integer amount + the eyeheight
    y = c * ΔB2 + expheight - 0.04 # real height of the explosion from the initial tnt position  
    ref_height = round(y)
    dh = y-ref_height # how far above or below the target value this alignment is

    # calculates the amount of tnt needed to put the packet just above the desired value and the new dh
    adj = 0
    new_dh = 0 
    new_y = 0
    if dh < 0
        adj = ceil(-dh/ΔT3)
        new_dh = adj * ΔT3 + dh
        new_y = y + new_dh
    end

    push!(alignments, Alignment(c,dh,y,adj,new_dh,new_y))
    println("Count: $c, Adj: $adj, ΔY: $dh, New ΔY: $new_dh")
end

a = alignments[findmin([abs(o.offset) for o in alignments])[2]]
#a = alignments[findmin([o.count + o.adj_count for o in alignments])[2]]

println("-----")
println("B2 Count: $(a.count)")
println("Offset: $(a.offset)")
println("T3 Count: $(a.adj_count)")
println("ΔY: $(a.adj_height)")
println("Adj Offset: $(a.adj_offset)")
println("Total K TNT per shot: $(a.count + a.adj_count)")
println("D Value: $(8 - a.adj_offset)")

# tnt equation because I'm lazy
println((a.adj_offset)/8 * 6//27)
