use starknet::ContractAddress;


#[starknet::interface]
trait IYASMeme<TContractState> {
    fn mint(ref self: TContractState, owner: ContractAddress, content: Array<felt252>, title: Array<felt252>, file_extension: Array<felt252>) -> bool;
    fn read_content(self: @TContractState) -> Array<felt252>;
    fn read_owner(self: @TContractState) -> ContractAddress;
    fn gift(ref self: TContractState, new_owner: ContractAddress) -> bool;
    fn read_title(self: @TContractState) -> Array<felt252>;
    fn write_title(ref self: TContractState, new_title: Array<felt252>) -> bool;
    fn read_caption(self: @TContractState) -> Array<felt252>;
    fn write_caption(ref self: TContractState, new_caption: Array<felt252>) -> bool;
    fn read_file_extension(self: @TContractState) -> Array<felt252>;
}

#[starknet::contract]
mod YASMeme {
    use super::IYASMeme;
    use starknet::{ContractAddress, get_caller_address};


    #[storage]
    struct Storage {
        title: Array<felt252>,
        content: Array<felt252>,
        owner: ContractAddress,
        caption: Array<felt252>,
        file_extension: Array<felt252> //.bmp, .png, etc
    }

    #[constructor]
    fn constructor(
        ref self: ContractState
    ) {
        self.owner.write(get_caller_address());
    }


    #[external(v0)]
    impl YASMemeImpl of IYASMeme<ContractState> {
        fn mint(ref self: ContractState, owner: ContractAddress, content: Array<felt252>, title: Array<felt252>, file_extension: Array<felt252>) -> bool {
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.content.write(content);
            self.title.write(title);
            self.owner.write(owner);
            self.file_extension.write(file_extension);
            true
        }
        
        fn read_content(self: @ContractState) -> Array<felt252> {
            self.content.read()
        }

        fn read_owner(self: @ContractState) -> ContractAddress{
            self.owner.read()
        }

        fn gift(ref self: ContractState, new_owner: ContractAddress) -> bool{
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.owner.write(new_owner);
            true
        }

        fn read_title(self: @ContractState) -> Array<felt252>{
            self.title.read()
        }

        fn write_title(ref self: ContractState, new_title: Array<felt252>) -> bool{
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.title.write(new_title);
            true
        }

        fn read_caption(self: @ContractState) -> Array<felt252>{
            self.caption.read()
        }

        fn write_caption(ref self: ContractState, new_caption: Array<felt252>) -> bool{
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.caption.write(new_caption);
            true
        }

        fn read_file_extension(self: @ContractState) -> Array<felt252>{
            self.file_extension.read()
        }
    }
}
