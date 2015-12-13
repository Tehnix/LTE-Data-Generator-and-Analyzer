"""
Prototype of Gold Sequence Generator

Testing in MatLab:
>> H = comm.GoldSequence('FirstPolynomial', [1 0 0 1 0 1],...
                         'SecondPolynomial', [1 1 1 1 0 1],...
                         'FirstInitialConditions', [1 0 0 1 0],...
                         'SecondInitialConditions', [1 1 1 1 0],...
                         'Index', 0,...
                         'SamplesPerFrame', 10);
>> x = step(H)'
x =     0     0     1     1     0     1     1     0     1     1

"""
from operator import xor


def pseudoNoise(polynomial, initial_state, output=False):
    """
    Note, that when saying the "last element" of the shift register, what is
    meant is the element at index 0, while the first element of the shift
    register is at index -1, i.e. we are reading right-to-left.

    """
    lfsr_reg = initial_state

    # Keep the PN generator running forever
    while True:
        # The output is the last element of the shift register
        lfsr_out = lfsr_reg[0]

        # FOR WHOM IT MAY CONCERN: Here is where I probably fuck up
        # Calculate the new input for the LFSR, by xor'ing it with the taps
        lfsr_in = lfsr_reg[0]
        # We loop from after the last element, and then until the first one
        for i in range(1, len(polynomial)):
            if polynomial[i-1] == 1:
                lfsr_in = xor(lfsr_in, lfsr_reg[i-1])
        # END OF FUCKING UP

        # Shift the register
        lfsr_reg = lfsr_reg[1:len(polynomial)-1] + [lfsr_in]
        if output:
            print(lfsr_out)
        yield lfsr_out


def goldSequenceGenerator(sequence_width_g):
    # Initialise the PNs
    pn1 = pseudoNoise(
        [1, 0, 0, 1, 0, 1],
        [0, 0, 0, 0, 1],
        output=False
    )
    pn2 = pseudoNoise(
        [1, 1, 1, 1, 0, 1],
        [0, 0, 0, 0, 1],
        output=False
    )
    # Make a list of zeros, the size of sequence_width_g
    bit_sequence = [0] * sequence_width_g
    # Keep track of when to output
    buffer_enable = False
    delay_counter = 0

    # Keep the generator running forever
    while True:
        buffer_enable = False
        delay_counter = 0
        while not buffer_enable:
            # If the delay counter is reached, this is the last loop
            if delay_counter == sequence_width_g - 1:
                buffer_enable = True
            pn1_data_out = next(pn1)
            pn2_data_out = next(pn2)
            data_out = xor(pn1_data_out, pn2_data_out)
            # Shift the output into the bit sequence
            bit_sequence = bit_sequence[0:sequence_width_g - 1] + [data_out]
            # Increment the delay counter
            delay_counter += 1
        yield bit_sequence


if __name__ == '__main__':
    gsg = goldSequenceGenerator(4)
    for i in range(0, 10):
        print(next(gsg))
