KS_distribution_test(values, distribution; p_value=0.05) = pvalue(ExactOneSampleKSTest(values, distribution)) > p_value
KS_uniformity_test(values, min, max; p_value=0.05) = KS_distribution_test(values, Uniform(min, max); p_value)
